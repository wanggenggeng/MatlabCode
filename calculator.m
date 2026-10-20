function result = calculator(a, op, b)
%CALCULATOR 简易四则运算计算器。
%   calculator             启动命令行交互，输入 q 退出。
%   calculator(12, '+', 3)  返回运算结果，支持 +、-、*、/。

    if nargin == 3
        result = calculate(a, op, b);
        return;
    elseif nargin ~= 0
        error('calculator:InvalidArguments', ...
            '请使用 calculator 或 calculator(数字, 运算符, 数字)。');
    end

    result = [];
    fprintf('简易计算器：支持 +、-、*、/，在任意提示处输入 q 退出。\n\n');

    while true
        first = strtrim(input('第一个数：', 's'));
        if strcmpi(first, 'q')
            return;
        end
        a = str2double(first);
        if ~is_valid_number(a)
            fprintf('输入无效，请输入有限实数，例如 -2.5 或 1e3。\n\n');
            continue;
        end

        op = strtrim(input('运算符（+ - * /）：', 's'));
        if strcmpi(op, 'q')
            return;
        end
        if ~any(strcmp(op, {'+', '-', '*', '/'}))
            fprintf('运算符无效，请使用 +、-、* 或 /。\n\n');
            continue;
        end

        second = strtrim(input('第二个数：', 's'));
        if strcmpi(second, 'q')
            return;
        end
        b = str2double(second);
        if ~is_valid_number(b)
            fprintf('输入无效，请输入有限实数，例如 -2.5 或 1e3。\n\n');
            continue;
        end

        try
            value = calculate(a, op, b);
            result = value;
            fprintf('%.15g %s %.15g = %.15g\n\n', a, op, b, result);
        catch exception
            if strncmp(exception.identifier, 'calculator:', 11)
                fprintf('错误：%s\n\n', exception.message);
            else
                rethrow(exception);
            end
        end
    end
end

function result = calculate(a, op, b)
    if ~is_valid_number(a) || ~is_valid_number(b)
        error('calculator:InvalidNumber', '两个操作数都必须是有限实数标量。');
    end

    if isstring(op) && isscalar(op)
        op = char(op);
    end
    if ~ischar(op) || size(op, 1) ~= 1
        error('calculator:InvalidOperator', '运算符必须为 +、-、* 或 /。');
    end
    op = strtrim(op);

    % 统一使用双精度，避免整数类型的截断或饱和运算。
    a = double(a);
    b = double(b);
    switch op
        case '+'
            result = a + b;
        case '-'
            result = a - b;
        case '*'
            result = a * b;
        case '/'
            if b == 0
                error('calculator:DivisionByZero', '除数不能为零。');
            end
            result = a / b;
        otherwise
            error('calculator:InvalidOperator', '运算符必须为 +、-、* 或 /。');
    end

    if ~isfinite(result)
        error('calculator:Overflow', '计算结果超出有限数值范围。');
    end
end

function valid = is_valid_number(value)
    valid = isnumeric(value) && isscalar(value) && ...
        isreal(value) && isfinite(value);
end
