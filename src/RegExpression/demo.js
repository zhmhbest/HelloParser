String.prototype.testMatch = function (reg) {
    //# /reg/  : 匹配一次后停止
    //# /reg/g : 全局匹配（重复匹配到结尾）
    //# /reg/i : 大小写不敏感
    //# /reg/m : 多行匹配
    console.log(this.replace(reg, s => {
        let buf = [];
        for(let i=0; i<s.length; i++) buf.push('■');
        return buf.join('');
    }));
};
const reg = require("./WiseRegExp");

// 原样匹配
console.log(reg.see("(\r.\n)"));

// 正则匹配
console.log(reg.out(/(\r.\n)/));

// demo1
const demo11 = reg.make({
    h: [/.../],
    b: [/[a-z]+/],
    t: [/.../],
}, 'g');
'???qwe???|???asd???'.testMatch(demo11);
'...qwe...|...asd...'.testMatch(demo11);
// ???■■■???|???■■■???
// ...■■■...|...■■■...

const demo12 = reg.make({
    h: ['...'],
    b: [/[a-z]+/],
    t: ['...'],
}, 'g');
'???qwe???|???asd???'.testMatch(demo12);
'...qwe...|...asd...'.testMatch(demo12);
// ???qwe???|???asd???
// ...■■■...|...■■■...


// demo2
const demo21 = reg.make([[/\r\n/, /\n/, /\r/]], 'g');
'...\r\n\n\r...'.testMatch(demo21);
'...\r\n...\n...\r...'.testMatch(demo21);
// ...■■■■...
// ...■■...■...■...
const demo22 = reg.make([/\r\n/, /\n/, /\r/], 'g');
'...\r\n\n\r...'.testMatch(demo22);
'...\r\n...\n...\r...'.testMatch(demo22);
// ...■■■■...
// ...\r\n...\n...\r...


// demo3
const demo3 = reg.make({
    nh: [/LLL/],
    b: [
        /.../, '...',
        {g: ['A', 'B']}, {g: ['A', 'B'], n: '+'}, {g: ['A', 'B'], n: [1, 2]},
        {o: ['M', 'N']}, {o: ['M', 'N'], n: '+'}, {o: ['M', 'N'], n: [1, 2]}, ['M', 'N'],
        {a: ['X', 'Y']},
    ],
    nt: [/RRR/],
});
console.log(demo3);
// /(?<!LLL)...\.\.\.(AB)(AB)+(AB){1,2}(M|N)(M|N)+(M|N){1,2}(M|N)XY(?!RRR)/



const regPhone = reg.make([/^/,
    {g: ['+86'], n: '?'},
    '1',
    /[0-9]{10}/,
/$/]);
console.log(regPhone);


const regWords = /[0-9a-zA-Z]+/
const regMail = reg.make([/^/,
    regWords,
    '@',
    {g: [regWords, '.'], n: '+'},
    regWords,
/$/]);
console.log(regMail);


const regIPNumCases = [/2[0-5]{2}/, /1[0-9]{2}/, /[1-9][0-9]/, /[0-9]/]
const regIP = reg.make([/^/, {g: [regIPNumCases, '.'], n: [3]}, regIPNumCases, /$/]);
console.log(regIP);
