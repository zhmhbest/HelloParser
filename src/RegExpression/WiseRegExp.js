/**
 * 原样匹配：显示什么就匹配什么
 * @param {String} s
 * @return {String}
 * @example \r 匹配 '\' + 'r'
 * @example \n 匹配 '\' + 'n'
 */
function seeString(s) {
    const buff = [];
    for (let ch of s) {
        switch (ch) {
            case '\t': buff.push('\\t'); break;
            case '\r': buff.push('\\r'); break;
            case '\n': buff.push('\\n'); break;
            case '[': case ']':
            case '(': case ')':
            case '{': case '}':
            case '^': case '$':
            case '.': case '|': case '\\':
            case '?': case '*': case '+':
                buff.push('\\');
                buff.push(ch);
                break;
            default:
                buff.push(ch);
        }
    }
    return buff.join('');
}


/**
 * 正则匹配：输出什么就匹配什么
 * @param {RegExp} r
 * @return {String}
 * @example \r 匹配 CR
 * @example \n 匹配 LF
 */
function outString(r) {
    const s = r.toString();
    return s.substring(1, s.length - 1);
}


/**
 * @typedef {RegExp | String} BasicArg
 * @typedef {BasicArg | BasicArg[]} ComposedArg
 * @typedef {{g?: ComposedArg[], o?: ComposedArg[], a?: ComposedArg[], n?: Number[] | String}} GroupArg
 * @typedef {Array<ComposedArg | GroupArg>} JoinArg
 * @typedef {{h?: ComposedArg[], nh?: ComposedArg[], b: ComposedArg[], t?: ComposedArg[], nt?: ComposedArg[]}} AssertArg
 */


/**
 * Group
 * @param {GroupArg} arg
 * @return {String}
 */
function groupString(arg) {
    if (undefined !== arg.g && arg.g instanceof Array) {
        // Group
        if (undefined !== arg.n) {
            if (arg.n instanceof Array) {
                return `(${andString(arg.g)}){${arg.n.join(',')}}`;
            } else {
                return `(${andString(arg.g)})${arg.n}`;
            }
        } else {
            return `(${andString(arg.g)})`;
        }
    } else if (undefined !== arg.o && arg.o instanceof Array) {
        // Or
        if (undefined !== arg.n) {
            if (arg.n instanceof Array) {
                return `${orString(arg.o)}{${arg.n.join(',')}}`;
            } else {
                return `${orString(arg.o)}${arg.n}`;
            }
        } else {
            return `${orString(arg.o)}`;
        }
    } else if (undefined !== arg.a && arg.a instanceof Array) {
        // And
        return andString(arg.a);
    }
    // Nothing
    return '';
}


/**
 * Join
 * @param {JoinArg} args
 * @return {Array<String>}
 */
function joinExpression(args) {
    const buff = [];

    for (let arg of args) {
        if (arg instanceof Array) {
            buff.push(orString(arg));
        } else if (arg instanceof RegExp) {
            buff.push(outString(arg));
        } else if (typeof arg === 'string') {
            buff.push(seeString(arg));
        } else if (arg instanceof Object) {
            buff.push(groupString(arg));
        } else {
            buff.push(arg.toString());
        }
    }

    return buff;
}
const joinString = (arr, sep) => joinExpression(arr).join(sep);
const orString = (arr) => `(${joinString(arr, '|')})`;
const andString = (arr) => `${joinString(arr, '')}`;



/**
 * 生成表达式
 * @param {JoinArg | AssertArg} obj
 * @param {String} flag
 * @return {RegExp}
 */
function makeExpression(obj, flag) {
    flag = flag || '';
    if (obj instanceof Array) {
        return new RegExp(andString(obj), flag);
    } else {
        const head = obj.h !== undefined ? `(?<=${andString(obj.h)})` : (
            obj.nh !== undefined ? `(?<!${andString(obj.nh)})` : ''
        );
        const body = obj.b !== undefined ? andString(obj.b) : '';
        const tail = obj.t !== undefined ? `(?=${andString(obj.t)})` : (
            obj.nt !== undefined ? `(?!${andString(obj.nt)})` : ''
        );
        return new RegExp(`${head}${body}${tail}`, flag);
    }
}


module.exports = {
    see: seeString,
    out: outString,
    make: makeExpression,
};