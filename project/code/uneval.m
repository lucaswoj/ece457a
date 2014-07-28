% http://www.mathworks.com/matlabcentral/fileexchange/19953-uneval

%uneval - Create eval'able string from a variable.
%
%string = uneval(value);
%string = uneval('varname', value);
%string = uneval('varname', value, false); % all lines concatenated
%strings = uneval('varname', value, true); % 1 line per string in cell entry
%
% Convert a MATLAB variable into a text string, which when evaluated,
% produces the original variable, and maintains machine precision for
% floating point values.
%
% This function handles many data types including structures of arrays of
% structurs but errors on unknown data types such as classes.
%
% Contrived usage:
% settings = load('some_data.mat');
% string = uneval('settings2', settings)
% eval(string);
% disp(isequalwithequalnans(settings, settings2));
%
% WARNING --- This probably won't work with handles to nested functions.

% Jan 2007 - D. Holl - Initial coding.
% I needed this utility for various odds & ends.
function the_string = uneval(var_name, value, return_cell_array)
switch nargin
  case 1
    value=var_name;
    var_name='';
    return_cell_array=false;
  case 2
    return_cell_array=false;
end
badchars = escape_sprintf;
reallybadchars = setdiff(char([0:31 127:255]), badchars);

% Get a cell array of strings:
the_string = value2strings(var_name, value);
if ~return_cell_array
  % Concatenate the strings with linefeeds after each:
  the_string = cellstr2string(the_string);
else
  % If the caller wanted cell array output, make sure it is a
  % column vector instead of a row.  (This is the standard for
  % MATLAB's multiline edit-text uicontrols.)
  the_string = the_string(:);
end
return;

  function strings = value2strings(var_name, value)
    strings = {};
    switch class(value)
      case {'int8', 'uint8', 'int16', 'uint16', 'int32', 'uint32', 'int64', 'uint64','single','double'}
        if isa(value, 'double')
          type_str1 = '';
          mat2str_args = {17}; % I ask for 17 digits to preserve doubles, and we don't need 'class' because MATLAB defaults to double.
        elseif isa(value, 'single')
          type_str1 = ', ''single''';
          mat2str_args = {8, 'class'}; % I ask for 8 digits to preserve singles
        else
          type_str1 = [', ''' class(value) ''''];
          mat2str_args = {'class'};
        end
        % mat2str also handles complex!
        if numel(value)>4 && all(arrayfun(@(x)isequalwithequalnans(value(1), x), value(:))) % make sure all elements are the same
          switch value(1)
            case 1
              strings{end+1} = ['ones(' mat2str(size(value)) type_str1 ')'];
            case -1
              strings{end+1} = ['-ones(' mat2str(size(value)) type_str1 ')'];
            case 0
              strings{end+1} = ['zeros(' mat2str(size(value)) type_str1 ')'];
            case inf
              strings{end+1} = ['inf(' mat2str(size(value)) type_str1 ')'];
            case -inf
              strings{end+1} = ['-inf(' mat2str(size(value)) type_str1 ')'];
            otherwise
              if isnan(value(1)) % Because "case nan" doesn't work.  (nan==nan is false)
                strings{end+1} = ['nan(' mat2str(size(value)) type_str1 ')'];
              else
                strings{end+1} = ['repmat(' mat2str(value(1),mat2str_args{:}) ', ' mat2str(size(value)) ')']; %don't need 'class' because MATLAB defaults to double
              end
          end
        else
          if ndims(value)>2
            % mat2str cannot handle ndims>2, so we flatten
            % value(:,:), and then output with reshape:
            strings{end+1} = ['reshape(' mat2str(value(:,:),mat2str_args{:}) ', ' mat2str(size(value)) ')'];
          else
            strings{end+1} = mat2str(value,mat2str_args{:});
          end
        end
        if ~isempty(var_name), strings{end} = sprintf('%s=%s;', var_name, strings{end}); end
      case 'char'
        value_size = size(value);
        % Hack for char matrices: make 'em look like rows:
        value = value(:).';
        if any(ismember(reallybadchars, value))
          % If they're really bad, convert them all to numbers:
          strings{end+1} = ['char(' mat2str(double(value)) ')'];
        elseif any(ismember(badchars, value))
          % If they're only a little bad, wrap them with sprintf:
          strings{end+1} = ['sprintf(''' escape_sprintf(value) ''')'];
        else
          % The string must be safe:
          strings{end+1} = ['''' value ''''];
        end
        % Now we preserve the original dimensions somehow:
        if numel(value_size)==2 && value_size(1)~=1 && value_size(2)==1
          % This is a column vector, so add a .' to the end:
          strings{end} = [strings{end} '.'''];
        elseif numel(value_size)>2 || value_size(1)~=1
          % This is either 2-D or higher dimensional:
          strings{end} = ['reshape(' strings{end} ', ' mat2str(value_size) ')'];
        end
        if ~isempty(var_name), strings{end} = sprintf('%s=%s;', var_name, strings{end}); end
      case 'logical'
        % I could group logicals with the numeric types, but that would
        % produce: [true false true true ...] instead of [1 0 1 1 ...].
        if numel(value)>4 && all(value(1)==value(:)) % make sure all elements are the same
          if value(1)
            strings{end+1} = ['true(' mat2str(size(value)) ')'];
          else
            strings{end+1} = ['false(' mat2str(size(value)) ')'];
          end
        else
          if ndims(value)>2
            % mat2str cannot handle ndims>2, so we flatten
            % value(:,:), and then output with reshape:
            strings{end+1} = ['reshape(logical(' mat2str(double(value(:,:))) '), ' mat2str(size(value)) ')'];
          else
            strings{end+1} = ['logical(' mat2str(double(value)) ')'];
          end
        end
        if ~isempty(var_name), strings{end} = sprintf('%s=%s;', var_name, strings{end}); end
      case 'function_handle'
        % WARNING --- This probably won't work with handles to nested
        % functions.
        strings{end+1} = func2str(value);
        if ~isempty(var_name), strings{end} = sprintf('%s=%s;', var_name, strings{end}); end
      case 'struct'
        value_size = size(value);
        if prod(value_size)==1
          strings{end+1} = 'struct';
        else
          strings{end+1} = ['repmat(struct, ' mat2str(value_size) ')'];
        end
        if ~isempty(var_name), strings{end} = sprintf('%s=%s;', var_name, strings{end}); end

        fields = fieldnames(value);

        for ndx=1:numel(value)
          if numel(value)==1
            subscripts = '';
          elseif numel(value_size)==2 && any(value_size==1)
            subscripts = sprintf('(%i)', ndx);
          else
            subscripts = cell_ind2sub(value_size, ndx);
            subscripts = sprintf('(%i%s)', subscripts(1), sprintf(',%i',subscripts(2:end)));
          end
          for fndx=1:numel(fields)
            sub_strings = value2strings(sprintf('%s%s.%s', var_name, subscripts, fields{fndx}), value(ndx).(fields{fndx}));
            strings = {strings{:}, sub_strings{:}};%#ok
          end
        end
      case 'cell'
        value_size = size(value);
        strings{end+1} = ['cell(' mat2str(value_size) ')'];
        if ~isempty(var_name), strings{end} = sprintf('%s=%s;', var_name, strings{end}); end
        for ndx=1:numel(value)
          if numel(value_size)==2 && any(value_size==1)
            subscripts = sprintf('{%i}', ndx);
          else
            subscripts = cell_ind2sub(value_size, ndx);
            subscripts = sprintf('{%i%s}', subscripts(1), sprintf(',%i',subscripts(2:end)));
          end
          sub_strings = value2strings(sprintf('%s%s', var_name, subscripts), value{ndx});
          strings = {strings{:}, sub_strings{:}};%#ok
        end
      otherwise
        error('uneval:unknown_class', 'Unknown class "%s", ', class(value));
    end
  end
end

%escape_sprintf - Escape a string to be used for sprintf formatting.
%
%string = escape_sprintf(string);
%badchars = escape_sprintf;
% Replace any "bad" characters in a string with sprintf escapes.
% If called with no input, return the list of characters that we'll replace.
%
% 1/2007 - D. Holl
function string = escape_sprintf(string)
% \\ must come BEFORE the other \ codes.
char_list = {'''', '%%', '\\', '\b', '\f', '\n', '\r', '\t'};
if nargin==0
  string = sprintf([char_list{:}]);
else
  for ndx=1:numel(char_list)
    char = sprintf(char_list{ndx});
    string = strrep(string, char, char_list{ndx});
  end
end
end

%CELLSTR2STRING - Concatenate multi-line array of strings into one string.
function the_string = cellstr2string(the_cellstr)
% Concatenate the strings with linefeeds after each:
LF = sprintf('\n');
the_cellstr = cellfun(@(x)[x LF], the_cellstr, 'UniformOutput', false);
the_string = [the_cellstr{:}];
end

%CELL_IND2SUB Multiple subscripts from linear index.
%   CELL_IND2SUB is used to determine the equivalent subscript values
%   corresponding to a given single index into an array.  This function
%   is identical to MATLAB's IND2SUB except that it returns all subscripts
%   as a single array.
%
% 3/2007 - D. Holl
function subscripts = cell_ind2sub(siz,ndx)
siz = double(siz);
subscripts = nan(size(siz));
k = [1 cumprod(siz(1:end-1))];
for i = numel(siz):-1:1,
  vi = rem(ndx-1, k(i)) + 1;
  vj = (ndx - vi)/k(i) + 1;
  subscripts(i) = vj;
  ndx = vi;
end
end
