function throttle(a, b, c) {
    var d, e, f, g = null,
    h = 0;
    c || (c = {});
    var i = function() {
        h = c.leading === !1 ? 0 : new Date,
        g = null,
        f = a.apply(d, e)
    };
    return function() {
        var j = new Date;
        h || c.leading !== !1 || (h = j);
        var k = b - (j - h);
        return d = this,
        e = arguments,
        0 >= k ? (clearTimeout(g), g = null, h = j, f = a.apply(d, e)) : g || c.trailing === !1 || (g = setTimeout(i, k)),
        f;
    }
}
function debounce(a, b, c) {
    var d, e, f, g, h;
    return function() {
        f = this,
        e = arguments,
        g = new Date;
        var i = function() {
            var j = new Date - g;
            b > j ? d = setTimeout(i, b - j) : (d = null, c || (h = a.apply(f, e)))
        },
        j = c && !d;
        return d || (d = setTimeout(i, b)),
        j && (h = a.apply(f, e)),
        h
    }
};
function Pager(a) {
    this.$monitor = a.monitor,
    this.nextUrl = a.nextUrl || "",
    this.$container = a.container,
    this.triggerType = "click" == a.triggerType ? "click": "lazyLoad",
    this.pauseInterval = parseInt(a.pauseInterval || 0, 10),
    this.loadCallback = a.onLoad ||
    function() {},
    this.errorCallback = a.onError ||
    function() {},
    this._stop = !1,
    this._pause = !1,
    this._lazyCount = 0,
    this.init();
    var b = this.triggerType,
    c = "init" + b.substring(0, 1).toUpperCase() + b.substring(1);
    $.isFunction(this[c]) && this[c]()
}
function Comment(a) {
    var b = window.$CONFIG || {},
    c = {
        container: null,
        code: null
    };
    this.page = 1,
    this.opts = $.extend(!0, c, a),
    this.$container = $(this.opts.container),
    b.openid && (this.user = {
        openid: b.openid,
        nickname: b.nickname,
        avatar: b.avatar
    }),
    this.createDOM(),
    this.bindEvent(),
    this.initPager()
}
function checkUpload() {
    var a = navigator.userAgent;
    if ( - 1 == a.indexOf("MicroMessenger")) return ! 0;
    var b = a.match(/MicroMessenger\/([\d\.]+)/);
    return b = parseFloat(b[1]),
    !isNaN(b) && b >= 5.2
}
function callApp(fun, param) {
    try {
        param || (param = "");
        var browserName = navigator.userAgent.toLowerCase();
        if ( - 1 != browserName.indexOf("android")) eval("window.pbwc." + fun + "('" + param + "');");
        else if ( - 1 != browserName.indexOf("iphone") || -1 != browserName.indexOf("ipad")) {
            var url = "pbwc:app*" + fun + "*" + param;
            document.location = url
        }
    } catch(e) {}
    return ! 1
} !
function(a, b, c) {
    function d(a) {
        return "[object Function]" == q.call(a)
    }
    function e(a) {
        return "string" == typeof a
    }
    function f() {}
    function g(a) {
        return ! a || "loaded" == a || "complete" == a || "uninitialized" == a
    }
    function h() {
        var a = r.shift();
        s = 1,
        a ? a.t ? o(function() { ("c" == a.t ? m.injectCss: m.injectJs)(a.s, 0, a.a, a.x, a.e, 1)
        },
        0) : (a(), h()) : s = 0
    }
    function i(a, c, d, e, f, i, j) {
        function k(b) {
            if (!n && g(l.readyState) && (t.r = n = 1, !s && h(), l.onload = l.onreadystatechange = null, b)) {
                "img" != a && o(function() {
                    v.removeChild(l)
                },
                50);
                for (var d in A[c]) A[c].hasOwnProperty(d) && A[c][d].onload()
            }
        }
        var j = j || m.errorTimeout,
        l = b.createElement(a),
        n = 0,
        q = 0,
        t = {
            t: d,
            s: c,
            e: f,
            a: i,
            x: j
        };
        1 === A[c] && (q = 1, A[c] = []),
        "object" == a ? l.data = c: (l.src = c, l.type = a),
        l.width = l.height = "0",
        l.onerror = l.onload = l.onreadystatechange = function() {
            k.call(this, q)
        },
        r.splice(e, 0, t),
        "img" != a && (q || 2 === A[c] ? (v.insertBefore(l, u ? null: p), o(k, j)) : A[c].push(l))
    }
    function j(a, b, c, d, f) {
        return s = 0,
        b = b || "j",
        e(a) ? i("c" == b ? x: w, a, b, this.i++, c, d, f) : (r.splice(this.i++, 0, a), 1 == r.length && h()),
        this
    }
    function k() {
        var a = m;
        return a.loader = {
            load: j,
            i: 0
        },
        a
    }
    var l, m, n = b.documentElement,
    o = a.setTimeout,
    p = b.getElementsByTagName("script")[0],
    q = {}.toString,
    r = [],
    s = 0,
    t = "MozAppearance" in n.style,
    u = t && !!b.createRange().compareNode,
    v = u ? n: p.parentNode,
    n = a.opera && "[object Opera]" == q.call(a.opera),
    n = !!b.attachEvent && !n,
    w = t ? "object": n ? "script": "img",
    x = n ? "script": w,
    y = Array.isArray ||
    function(a) {
        return "[object Array]" == q.call(a)
    },
    z = [],
    A = {},
    B = {
        timeout: function(a, b) {
            return b.length && (a.timeout = b[0]),
            a
        }
    };
    m = function(a) {
        function b(a) {
            var b, c, d, a = a.split("!"),
            e = z.length,
            f = a.pop(),
            g = a.length,
            f = {
                url: f,
                origUrl: f,
                prefixes: a
            };
            for (c = 0; g > c; c++) d = a[c].split("="),
            (b = B[d.shift()]) && (f = b(f, d));
            for (c = 0; e > c; c++) f = z[c](f);
            return f
        }
        function g(a, e, f, g, h) {
            var i = b(a),
            j = i.autoCallback;
            i.url.split(".").pop().split("?").shift(),
            i.bypass || (e && (e = d(e) ? e: e[a] || e[g] || e[a.split("/").pop().split("?")[0]]), i.instead ? i.instead(a, e, f, g, h) : (A[i.url] ? i.noexec = !0 : A[i.url] = 1, f.load(i.url, i.forceCSS || !i.forceJS && "css" == i.url.split(".").pop().split("?").shift() ? "c": c, i.noexec, i.attrs, i.timeout), (d(e) || d(j)) && f.load(function() {
                k(),
                e && e(i.origUrl, h, g),
                j && j(i.origUrl, h, g),
                A[i.url] = 2
            })))
        }
        function h(a, b) {
            function c(a, c) {
                if (a) {
                    if (e(a)) c || (l = function() {
                        var a = [].slice.call(arguments);
                        m.apply(this, a),
                        n()
                    }),
                    g(a, l, b, 0, j);
                    else if (Object(a) === a) for (i in h = function() {
                        var b, c = 0;
                        for (b in a) a.hasOwnProperty(b) && c++;
                        return c
                    } (), a) a.hasOwnProperty(i) && (!c && !--h && (d(l) ? l = function() {
                        var a = [].slice.call(arguments);
                        m.apply(this, a),
                        n()
                    }: l[i] = function(a) {
                        return function() {
                            var b = [].slice.call(arguments);
                            a && a.apply(this, b),
                            n()
                        }
                    } (m[i])), g(a[i], l, b, i, j))
                } else ! c && n()
            }
            var h, i, j = !!a.test,
            k = a.load || a.both,
            l = a.callback || f,
            m = l,
            n = a.complete || f;
            c(j ? a.yep: a.nope, !!k),
            k && c(k)
        }
        var i, j, l = this.yepnope.loader;
        if (e(a)) g(a, 0, l, 0);
        else if (y(a)) for (i = 0; i < a.length; i++) j = a[i],
        e(j) ? g(j, 0, l, 0) : y(j) ? m(j) : Object(j) === j && h(j, l);
        else Object(a) === a && h(a, l)
    },
    m.addPrefix = function(a, b) {
        B[a] = b
    },
    m.addFilter = function(a) {
        z.push(a)
    },
    m.errorTimeout = 1e4,
    null == b.readyState && b.addEventListener && (b.readyState = "loading", b.addEventListener("DOMContentLoaded", l = function() {
        b.removeEventListener("DOMContentLoaded", l, 0),
        b.readyState = "complete"
    },
    0)),
    a.yepnope = k(),
    a.yepnope.executeStack = h,
    a.yepnope.injectJs = function(a, c, d, e, i, j) {
        var k, l, n = b.createElement("script"),
        e = e || m.errorTimeout;
        n.src = a;
        for (l in d) n.setAttribute(l, d[l]);
        c = j ? h: c || f,
        n.onreadystatechange = n.onload = function() { ! k && g(n.readyState) && (k = 1, c(), n.onload = n.onreadystatechange = null)
        },
        o(function() {
            k || (k = 1, c(1))
        },
        e),
        i ? n.onload() : p.parentNode.insertBefore(n, p)
    },
    a.yepnope.injectCss = function(a, c, d, e, g, i) {
        var j, e = b.createElement("link"),
        c = i ? h: c || f;
        e.href = a,
        e.rel = "stylesheet",
        e.type = "text/css";
        for (j in d) e.setAttribute(j, d[j]);
        g || (p.parentNode.insertBefore(e, p), o(c, 0))
    }
} (this, document);
var Zepto = function() {
    function a(a) {
        return null == a ? String(a) : V[W.call(a)] || "object"
    }
    function b(b) {
        return "function" == a(b)
    }
    function c(a) {
        return null != a && a == a.window
    }
    function d(a) {
        return null != a && a.nodeType == a.DOCUMENT_NODE
    }
    function e(b) {
        return "object" == a(b)
    }
    function f(a) {
        return e(a) && !c(a) && Object.getPrototypeOf(a) == Object.prototype
    }
    function g(a) {
        return a instanceof Array
    }
    function h(a) {
        return "number" == typeof a.length
    }
    function i(a) {
        return E.call(a,
        function(a) {
            return null != a
        })
    }
    function j(a) {
        return a.length > 0 ? y.fn.concat.apply([], a) : a
    }
    function k(a) {
        return a.replace(/::/g, "/").replace(/([A-Z]+)([A-Z][a-z])/g, "$1_$2").replace(/([a-z\d])([A-Z])/g, "$1_$2").replace(/_/g, "-").toLowerCase()
    }
    function l(a) {
        return a in H ? H[a] : H[a] = new RegExp("(^|\\s)" + a + "(\\s|$)")
    }
    function m(a, b) {
        return "number" != typeof b || I[k(a)] ? b: b + "px"
    }
    function n(a) {
        var b, c;
        return G[a] || (b = F.createElement(a), F.body.appendChild(b), c = getComputedStyle(b, "").getPropertyValue("display"), b.parentNode.removeChild(b), "none" == c && (c = "block"), G[a] = c),
        G[a]
    }
    function o(a) {
        return "children" in a ? D.call(a.children) : y.map(a.childNodes,
        function(a) {
            return 1 == a.nodeType ? a: void 0
        })
    }
    function p(a, b, c) {
        for (x in b) c && (f(b[x]) || g(b[x])) ? (f(b[x]) && !f(a[x]) && (a[x] = {}), g(b[x]) && !g(a[x]) && (a[x] = []), p(a[x], b[x], c)) : b[x] !== w && (a[x] = b[x])
    }
    function q(a, b) {
        return null == b ? y(a) : y(a).filter(b)
    }
    function r(a, c, d, e) {
        return b(c) ? c.call(a, d, e) : c
    }
    function s(a, b, c) {
        null == c ? a.removeAttribute(b) : a.setAttribute(b, c)
    }
    function t(a, b) {
        var c = a.className,
        d = c && c.baseVal !== w;
        return b === w ? d ? c.baseVal: c: (d ? c.baseVal = b: a.className = b, void 0)
    }
    function u(a) {
        var b;
        try {
            return a ? "true" == a || ("false" == a ? !1 : "null" == a ? null: /^0/.test(a) || isNaN(b = Number(a)) ? /^[\[\{]/.test(a) ? y.parseJSON(a) : a: b) : a
        } catch(c) {
            return a
        }
    }
    function v(a, b) {
        b(a);
        for (var c in a.childNodes) v(a.childNodes[c], b)
    }
    var w, x, y, z, A, B, C = [],
    D = C.slice,
    E = C.filter,
    F = window.document,
    G = {},
    H = {},
    I = {
        "column-count": 1,
        columns: 1,
        "font-weight": 1,
        "line-height": 1,
        opacity: 1,
        "z-index": 1,
        zoom: 1
    },
    J = /^\s*<(\w+|!)[^>]*>/,
    K = /^<(\w+)\s*\/?>(?:<\/\1>|)$/,
    L = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi,
    M = /^(?:body|html)$/i,
    N = /([A-Z])/g,
    O = ["val", "css", "html", "text", "data", "width", "height", "offset"],
    P = ["after", "prepend", "before", "append"],
    Q = F.createElement("table"),
    R = F.createElement("tr"),
    S = {
        tr: F.createElement("tbody"),
        tbody: Q,
        thead: Q,
        tfoot: Q,
        td: R,
        th: R,
        "*": F.createElement("div")
    },
    T = /complete|loaded|interactive/,
    U = /^[\w-]*$/,
    V = {},
    W = V.toString,
    X = {},
    Y = F.createElement("div"),
    Z = {
        tabindex: "tabIndex",
        readonly: "readOnly",
        "for": "htmlFor",
        "class": "className",
        maxlength: "maxLength",
        cellspacing: "cellSpacing",
        cellpadding: "cellPadding",
        rowspan: "rowSpan",
        colspan: "colSpan",
        usemap: "useMap",
        frameborder: "frameBorder",
        contenteditable: "contentEditable"
    };
    return X.matches = function(a, b) {
        if (!b || !a || 1 !== a.nodeType) return ! 1;
        var c = a.webkitMatchesSelector || a.mozMatchesSelector || a.oMatchesSelector || a.matchesSelector;
        if (c) return c.call(a, b);
        var d, e = a.parentNode,
        f = !e;
        return f && (e = Y).appendChild(a),
        d = ~X.qsa(e, b).indexOf(a),
        f && Y.removeChild(a),
        d
    },
    A = function(a) {
        return a.replace(/-+(.)?/g,
        function(a, b) {
            return b ? b.toUpperCase() : ""
        })
    },
    B = function(a) {
        return E.call(a,
        function(b, c) {
            return a.indexOf(b) == c
        })
    },
    X.fragment = function(a, b, c) {
        var d, e, g;
        return K.test(a) && (d = y(F.createElement(RegExp.$1))),
        d || (a.replace && (a = a.replace(L, "<$1></$2>")), b === w && (b = J.test(a) && RegExp.$1), b in S || (b = "*"), g = S[b], g.innerHTML = "" + a, d = y.each(D.call(g.childNodes),
        function() {
            g.removeChild(this)
        })),
        f(c) && (e = y(d), y.each(c,
        function(a, b) {
            O.indexOf(a) > -1 ? e[a](b) : e.attr(a, b)
        })),
        d
    },
    X.Z = function(a, b) {
        return a = a || [],
        a.__proto__ = y.fn,
        a.selector = b || "",
        a
    },
    X.isZ = function(a) {
        return a instanceof X.Z
    },
    X.init = function(a, c) {
        var d;
        if (!a) return X.Z();
        if ("string" == typeof a) if (a = a.trim(), "<" == a[0] && J.test(a)) d = X.fragment(a, RegExp.$1, c),
        a = null;
        else {
            if (c !== w) return y(c).find(a);
            d = X.qsa(F, a)
        } else {
            if (b(a)) return y(F).ready(a);
            if (X.isZ(a)) return a;
            if (g(a)) d = i(a);
            else if (e(a)) d = [a],
            a = null;
            else if (J.test(a)) d = X.fragment(a.trim(), RegExp.$1, c),
            a = null;
            else {
                if (c !== w) return y(c).find(a);
                d = X.qsa(F, a)
            }
        }
        return X.Z(d, a)
    },
    y = function(a, b) {
        return X.init(a, b)
    },
    y.extend = function(a) {
        var b, c = D.call(arguments, 1);
        return "boolean" == typeof a && (b = a, a = c.shift()),
        c.forEach(function(c) {
            p(a, c, b)
        }),
        a
    },
    X.qsa = function(a, b) {
        var c, e = "#" == b[0],
        f = !e && "." == b[0],
        g = e || f ? b.slice(1) : b,
        h = U.test(g);
        return d(a) && h && e ? (c = a.getElementById(g)) ? [c] : [] : 1 !== a.nodeType && 9 !== a.nodeType ? [] : D.call(h && !e ? f ? a.getElementsByClassName(g) : a.getElementsByTagName(b) : a.querySelectorAll(b))
    },
    y.contains = function(a, b) {
        return a !== b && a.contains(b)
    },
    y.type = a,
    y.isFunction = b,
    y.isWindow = c,
    y.isArray = g,
    y.isPlainObject = f,
    y.isEmptyObject = function(a) {
        var b;
        for (b in a) return ! 1;
        return ! 0
    },
    y.inArray = function(a, b, c) {
        return C.indexOf.call(b, a, c)
    },
    y.camelCase = A,
    y.trim = function(a) {
        return null == a ? "": String.prototype.trim.call(a)
    },
    y.uuid = 0,
    y.support = {},
    y.expr = {},
    y.map = function(a, b) {
        var c, d, e, f = [];
        if (h(a)) for (d = 0; d < a.length; d++) c = b(a[d], d),
        null != c && f.push(c);
        else for (e in a) c = b(a[e], e),
        null != c && f.push(c);
        return j(f)
    },
    y.each = function(a, b) {
        var c, d;
        if (h(a)) {
            for (c = 0; c < a.length; c++) if (b.call(a[c], c, a[c]) === !1) return a
        } else for (d in a) if (b.call(a[d], d, a[d]) === !1) return a;
        return a
    },
    y.grep = function(a, b) {
        return E.call(a, b)
    },
    window.JSON && (y.parseJSON = JSON.parse),
    y.each("Boolean Number String Function Array Date RegExp Object Error".split(" "),
    function(a, b) {
        V["[object " + b + "]"] = b.toLowerCase()
    }),
    y.fn = {
        forEach: C.forEach,
        reduce: C.reduce,
        push: C.push,
        sort: C.sort,
        indexOf: C.indexOf,
        concat: C.concat,
        map: function(a) {
            return y(y.map(this,
            function(b, c) {
                return a.call(b, c, b)
            }))
        },
        slice: function() {
            return y(D.apply(this, arguments))
        },
        ready: function(a) {
            return T.test(F.readyState) && F.body ? a(y) : F.addEventListener("DOMContentLoaded",
            function() {
                a(y)
            },
            !1),
            this
        },
        get: function(a) {
            return a === w ? D.call(this) : this[a >= 0 ? a: a + this.length]
        },
        toArray: function() {
            return this.get()
        },
        size: function() {
            return this.length
        },
        remove: function() {
            return this.each(function() {
                null != this.parentNode && this.parentNode.removeChild(this)
            })
        },
        each: function(a) {
            return C.every.call(this,
            function(b, c) {
                return a.call(b, c, b) !== !1
            }),
            this
        },
        filter: function(a) {
            return b(a) ? this.not(this.not(a)) : y(E.call(this,
            function(b) {
                return X.matches(b, a)
            }))
        },
        add: function(a, b) {
            return y(B(this.concat(y(a, b))))
        },
        is: function(a) {
            return this.length > 0 && X.matches(this[0], a)
        },
        not: function(a) {
            var c = [];
            if (b(a) && a.call !== w) this.each(function(b) {
                a.call(this, b) || c.push(this)
            });
            else {
                var d = "string" == typeof a ? this.filter(a) : h(a) && b(a.item) ? D.call(a) : y(a);
                this.forEach(function(a) {
                    d.indexOf(a) < 0 && c.push(a)
                })
            }
            return y(c)
        },
        has: function(a) {
            return this.filter(function() {
                return e(a) ? y.contains(this, a) : y(this).find(a).size()
            })
        },
        eq: function(a) {
            return - 1 === a ? this.slice(a) : this.slice(a, +a + 1)
        },
        first: function() {
            var a = this[0];
            return a && !e(a) ? a: y(a)
        },
        last: function() {
            var a = this[this.length - 1];
            return a && !e(a) ? a: y(a)
        },
        find: function(a) {
            var b, c = this;
            return b = "object" == typeof a ? y(a).filter(function() {
                var a = this;
                return C.some.call(c,
                function(b) {
                    return y.contains(b, a)
                })
            }) : 1 == this.length ? y(X.qsa(this[0], a)) : this.map(function() {
                return X.qsa(this, a)
            })
        },
        closest: function(a, b) {
            var c = this[0],
            e = !1;
            for ("object" == typeof a && (e = y(a)); c && !(e ? e.indexOf(c) >= 0 : X.matches(c, a));) c = c !== b && !d(c) && c.parentNode;
            return y(c)
        },
        parents: function(a) {
            for (var b = [], c = this; c.length > 0;) c = y.map(c,
            function(a) {
                return (a = a.parentNode) && !d(a) && b.indexOf(a) < 0 ? (b.push(a), a) : void 0
            });
            return q(b, a)
        },
        parent: function(a) {
            return q(B(this.pluck("parentNode")), a)
        },
        children: function(a) {
            return q(this.map(function() {
                return o(this)
            }), a)
        },
        contents: function() {
            return this.map(function() {
                return D.call(this.childNodes)
            })
        },
        siblings: function(a) {
            return q(this.map(function(a, b) {
                return E.call(o(b.parentNode),
                function(a) {
                    return a !== b
                })
            }), a)
        },
        empty: function() {
            return this.each(function() {
                this.innerHTML = ""
            })
        },
        pluck: function(a) {
            return y.map(this,
            function(b) {
                return b[a]
            })
        },
        show: function() {
            return this.each(function() {
                "none" == this.style.display && (this.style.display = ""),
                "none" == getComputedStyle(this, "").getPropertyValue("display") && (this.style.display = n(this.nodeName))
            })
        },
        replaceWith: function(a) {
            return this.before(a).remove()
        },
        wrap: function(a) {
            var c = b(a);
            if (this[0] && !c) var d = y(a).get(0),
            e = d.parentNode || this.length > 1;
            return this.each(function(b) {
                y(this).wrapAll(c ? a.call(this, b) : e ? d.cloneNode(!0) : d)
            })
        },
        wrapAll: function(a) {
            if (this[0]) {
                y(this[0]).before(a = y(a));
                for (var b; (b = a.children()).length;) a = b.first();
                y(a).append(this)
            }
            return this
        },
        wrapInner: function(a) {
            var c = b(a);
            return this.each(function(b) {
                var d = y(this),
                e = d.contents(),
                f = c ? a.call(this, b) : a;
                e.length ? e.wrapAll(f) : d.append(f)
            })
        },
        unwrap: function() {
            return this.parent().each(function() {
                y(this).replaceWith(y(this).children())
            }),
            this
        },
        clone: function() {
            return this.map(function() {
                return this.cloneNode(!0)
            })
        },
        hide: function() {
            return this.css("display", "none")
        },
        toggle: function(a) {
            return this.each(function() {
                var b = y(this); (a === w ? "none" == b.css("display") : a) ? b.show() : b.hide()
            })
        },
        prev: function(a) {
            return y(this.pluck("previousElementSibling")).filter(a || "*")
        },
        next: function(a) {
            return y(this.pluck("nextElementSibling")).filter(a || "*")
        },
        html: function(a) {
            return 0 === arguments.length ? this.length > 0 ? this[0].innerHTML: null: this.each(function(b) {
                var c = this.innerHTML;
                y(this).empty().append(r(this, a, b, c))
            })
        },
        text: function(a) {
            return 0 === arguments.length ? this.length > 0 ? this[0].textContent: null: this.each(function() {
                this.textContent = a === w ? "": "" + a
            })
        },
        attr: function(a, b) {
            var c;
            return "string" == typeof a && b === w ? 0 == this.length || 1 !== this[0].nodeType ? w: "value" == a && "INPUT" == this[0].nodeName ? this.val() : !(c = this[0].getAttribute(a)) && a in this[0] ? this[0][a] : c: this.each(function(c) {
                if (1 === this.nodeType) if (e(a)) for (x in a) s(this, x, a[x]);
                else s(this, a, r(this, b, c, this.getAttribute(a)))
            })
        },
        removeAttr: function(a) {
            return this.each(function() {
                1 === this.nodeType && s(this, a)
            })
        },
        prop: function(a, b) {
            return a = Z[a] || a,
            b === w ? this[0] && this[0][a] : this.each(function(c) {
                this[a] = r(this, b, c, this[a])
            })
        },
        data: function(a, b) {
            var c = this.attr("data-" + a.replace(N, "-$1").toLowerCase(), b);
            return null !== c ? u(c) : w
        },
        val: function(a) {
            return 0 === arguments.length ? this[0] && (this[0].multiple ? y(this[0]).find("option").filter(function() {
                return this.selected
            }).pluck("value") : this[0].value) : this.each(function(b) {
                this.value = r(this, a, b, this.value)
            })
        },
        offset: function(a) {
            if (a) return this.each(function(b) {
                var c = y(this),
                d = r(this, a, b, c.offset()),
                e = c.offsetParent().offset(),
                f = {
                    top: d.top - e.top,
                    left: d.left - e.left
                };
                "static" == c.css("position") && (f.position = "relative"),
                c.css(f)
            });
            if (0 == this.length) return null;
            var b = this[0].getBoundingClientRect();
            return {
                left: b.left + window.pageXOffset,
                top: b.top + window.pageYOffset,
                width: Math.round(b.width),
                height: Math.round(b.height)
            }
        },
        css: function(b, c) {
            if (arguments.length < 2) {
                var d = this[0],
                e = getComputedStyle(d, "");
                if (!d) return;
                if ("string" == typeof b) return d.style[A(b)] || e.getPropertyValue(b);
                if (g(b)) {
                    var f = {};
                    return y.each(g(b) ? b: [b],
                    function(a, b) {
                        f[b] = d.style[A(b)] || e.getPropertyValue(b)
                    }),
                    f
                }
            }
            var h = "";
            if ("string" == a(b)) c || 0 === c ? h = k(b) + ":" + m(b, c) : this.each(function() {
                this.style.removeProperty(k(b))
            });
            else for (x in b) b[x] || 0 === b[x] ? h += k(x) + ":" + m(x, b[x]) + ";": this.each(function() {
                this.style.removeProperty(k(x))
            });
            return this.each(function() {
                this.style.cssText += ";" + h
            })
        },
        index: function(a) {
            return a ? this.indexOf(y(a)[0]) : this.parent().children().indexOf(this[0])
        },
        hasClass: function(a) {
            return a ? C.some.call(this,
            function(a) {
                return this.test(t(a))
            },
            l(a)) : !1
        },
        addClass: function(a) {
            return a ? this.each(function(b) {
                z = [];
                var c = t(this),
                d = r(this, a, b, c);
                d.split(/\s+/g).forEach(function(a) {
                    y(this).hasClass(a) || z.push(a)
                },
                this),
                z.length && t(this, c + (c ? " ": "") + z.join(" "))
            }) : this
        },
        removeClass: function(a) {
            return this.each(function(b) {
                return a === w ? t(this, "") : (z = t(this), r(this, a, b, z).split(/\s+/g).forEach(function(a) {
                    z = z.replace(l(a), " ")
                }), t(this, z.trim()), void 0)
            })
        },
        toggleClass: function(a, b) {
            return a ? this.each(function(c) {
                var d = y(this),
                e = r(this, a, c, t(this));
                e.split(/\s+/g).forEach(function(a) { (b === w ? !d.hasClass(a) : b) ? d.addClass(a) : d.removeClass(a)
                })
            }) : this
        },
        scrollTop: function(a) {
            if (this.length) {
                var b = "scrollTop" in this[0];
                return a === w ? b ? this[0].scrollTop: this[0].pageYOffset: this.each(b ?
                function() {
                    this.scrollTop = a
                }: function() {
                    this.scrollTo(this.scrollX, a)
                })
            }
        },
        scrollLeft: function(a) {
            if (this.length) {
                var b = "scrollLeft" in this[0];
                return a === w ? b ? this[0].scrollLeft: this[0].pageXOffset: this.each(b ?
                function() {
                    this.scrollLeft = a
                }: function() {
                    this.scrollTo(a, this.scrollY)
                })
            }
        },
        position: function() {
            if (this.length) {
                var a = this[0],
                b = this.offsetParent(),
                c = this.offset(),
                d = M.test(b[0].nodeName) ? {
                    top: 0,
                    left: 0
                }: b.offset();
                return c.top -= parseFloat(y(a).css("margin-top")) || 0,
                c.left -= parseFloat(y(a).css("margin-left")) || 0,
                d.top += parseFloat(y(b[0]).css("border-top-width")) || 0,
                d.left += parseFloat(y(b[0]).css("border-left-width")) || 0,
                {
                    top: c.top - d.top,
                    left: c.left - d.left
                }
            }
        },
        offsetParent: function() {
            return this.map(function() {
                for (var a = this.offsetParent || F.body; a && !M.test(a.nodeName) && "static" == y(a).css("position");) a = a.offsetParent;
                return a
            })
        }
    },
    y.fn.detach = y.fn.remove,
    ["width", "height"].forEach(function(a) {
        var b = a.replace(/./,
        function(a) {
            return a[0].toUpperCase()
        });
        y.fn[a] = function(e) {
            var f, g = this[0];
            return e === w ? c(g) ? g["inner" + b] : d(g) ? g.documentElement["scroll" + b] : (f = this.offset()) && f[a] : this.each(function(b) {
                g = y(this),
                g.css(a, r(this, e, b, g[a]()))
            })
        }
    }),
    P.forEach(function(b, c) {
        var d = c % 2;
        y.fn[b] = function() {
            var b, e, f = y.map(arguments,
            function(c) {
                return b = a(c),
                "object" == b || "array" == b || null == c ? c: X.fragment(c)
            }),
            g = this.length > 1;
            return f.length < 1 ? this: this.each(function(a, b) {
                e = d ? b: b.parentNode,
                b = 0 == c ? b.nextSibling: 1 == c ? b.firstChild: 2 == c ? b: null,
                f.forEach(function(a) {
                    if (g) a = a.cloneNode(!0);
                    else if (!e) return y(a).remove();
                    v(e.insertBefore(a, b),
                    function(a) {
                        null == a.nodeName || "SCRIPT" !== a.nodeName.toUpperCase() || a.type && "text/javascript" !== a.type || a.src || window.eval.call(window, a.innerHTML)
                    })
                })
            })
        },
        y.fn[d ? b + "To": "insert" + (c ? "Before": "After")] = function(a) {
            return y(a)[b](this),
            this
        }
    }),
    X.Z.prototype = y.fn,
    X.uniq = B,
    X.deserializeValue = u,
    y.zepto = X,
    y
} ();
window.Zepto = Zepto,
void 0 === window.$ && (window.$ = Zepto),
function(a) {
    function b(a) {
        return a._zid || (a._zid = m++)
    }
    function c(a, c, f, g) {
        if (c = d(c), c.ns) var h = e(c.ns);
        return (q[b(a)] || []).filter(function(a) {
            return ! (!a || c.e && a.e != c.e || c.ns && !h.test(a.ns) || f && b(a.fn) !== b(f) || g && a.sel != g)
        })
    }
    function d(a) {
        var b = ("" + a).split(".");
        return {
            e: b[0],
            ns: b.slice(1).sort().join(" ")
        }
    }
    function e(a) {
        return new RegExp("(?:^| )" + a.replace(" ", " .* ?") + "(?: |$)")
    }
    function f(a, b) {
        return a.del && !s && a.e in t || !!b
    }
    function g(a) {
        return u[a] || s && t[a] || a
    }
    function h(c, e, h, i, k, m, n) {
        var o = b(c),
        p = q[o] || (q[o] = []);
        e.split(/\s/).forEach(function(b) {
            if ("ready" == b) return a(document).ready(h);
            var e = d(b);
            e.fn = h,
            e.sel = k,
            e.e in u && (h = function(b) {
                var c = b.relatedTarget;
                return ! c || c !== this && !a.contains(this, c) ? e.fn.apply(this, arguments) : void 0
            }),
            e.del = m;
            var o = m || h;
            e.proxy = function(a) {
                if (a = j(a), !a.isImmediatePropagationStopped()) {
                    a.data = i;
                    var b = o.apply(c, a._args == l ? [a] : [a].concat(a._args));
                    return b === !1 && (a.preventDefault(), a.stopPropagation()),
                    b
                }
            },
            e.i = p.length,
            p.push(e),
            "addEventListener" in c && c.addEventListener(g(e.e), e.proxy, f(e, n))
        })
    }
    function i(a, d, e, h, i) {
        var j = b(a); (d || "").split(/\s/).forEach(function(b) {
            c(a, b, e, h).forEach(function(b) {
                delete q[j][b.i],
                "removeEventListener" in a && a.removeEventListener(g(b.e), b.proxy, f(b, i))
            })
        })
    }
    function j(b, c) {
        return (c || !b.isDefaultPrevented) && (c || (c = b), a.each(y,
        function(a, d) {
            var e = c[a];
            b[a] = function() {
                return this[d] = v,
                e && e.apply(c, arguments)
            },
            b[d] = w
        }), (c.defaultPrevented !== l ? c.defaultPrevented: "returnValue" in c ? c.returnValue === !1 : c.getPreventDefault && c.getPreventDefault()) && (b.isDefaultPrevented = v)),
        b
    }
    function k(a) {
        var b, c = {
            originalEvent: a
        };
        for (b in a) x.test(b) || a[b] === l || (c[b] = a[b]);
        return j(c, a)
    }
    var l, m = (a.zepto.qsa, 1),
    n = Array.prototype.slice,
    o = a.isFunction,
    p = function(a) {
        return "string" == typeof a
    },
    q = {},
    r = {},
    s = "onfocusin" in window,
    t = {
        focus: "focusin",
        blur: "focusout"
    },
    u = {
        mouseenter: "mouseover",
        mouseleave: "mouseout"
    };
    r.click = r.mousedown = r.mouseup = r.mousemove = "MouseEvents",
    a.event = {
        add: h,
        remove: i
    },
    a.proxy = function(c, d) {
        if (o(c)) {
            var e = function() {
                return c.apply(d, arguments)
            };
            return e._zid = b(c),
            e
        }
        if (p(d)) return a.proxy(c[d], c);
        throw new TypeError("expected function")
    },
    a.fn.bind = function(a, b, c) {
        return this.on(a, b, c)
    },
    a.fn.unbind = function(a, b) {
        return this.off(a, b)
    },
    a.fn.one = function(a, b, c, d) {
        return this.on(a, b, c, d, 1)
    };
    var v = function() {
        return ! 0
    },
    w = function() {
        return ! 1
    },
    x = /^([A-Z]|returnValue$|layer[XY]$)/,
    y = {
        preventDefault: "isDefaultPrevented",
        stopImmediatePropagation: "isImmediatePropagationStopped",
        stopPropagation: "isPropagationStopped"
    };
    a.fn.delegate = function(a, b, c) {
        return this.on(b, a, c)
    },
    a.fn.undelegate = function(a, b, c) {
        return this.off(b, a, c)
    },
    a.fn.live = function(b, c) {
        return a(document.body).delegate(this.selector, b, c),
        this
    },
    a.fn.die = function(b, c) {
        return a(document.body).undelegate(this.selector, b, c),
        this
    },
    a.fn.on = function(b, c, d, e, f) {
        var g, j, m = this;
        return b && !p(b) ? (a.each(b,
        function(a, b) {
            m.on(a, c, d, b, f)
        }), m) : (p(c) || o(e) || e === !1 || (e = d, d = c, c = l), (o(d) || d === !1) && (e = d, d = l), e === !1 && (e = w), m.each(function(l, m) {
            f && (g = function(a) {
                return i(m, a.type, e),
                e.apply(this, arguments)
            }),
            c && (j = function(b) {
                var d, f = a(b.target).closest(c, m).get(0);
                return f && f !== m ? (d = a.extend(k(b), {
                    currentTarget: f,
                    liveFired: m
                }), (g || e).apply(f, [d].concat(n.call(arguments, 1)))) : void 0
            }),
            h(m, b, e, d, c, j || g)
        }))
    },
    a.fn.off = function(b, c, d) {
        var e = this;
        return b && !p(b) ? (a.each(b,
        function(a, b) {
            e.off(a, c, b)
        }), e) : (p(c) || o(d) || d === !1 || (d = c, c = l), d === !1 && (d = w), e.each(function() {
            i(this, b, d, c)
        }))
    },
    a.fn.trigger = function(b, c) {
        return b = p(b) || a.isPlainObject(b) ? a.Event(b) : j(b),
        b._args = c,
        this.each(function() {
            "dispatchEvent" in this ? this.dispatchEvent(b) : a(this).triggerHandler(b, c)
        })
    },
    a.fn.triggerHandler = function(b, d) {
        var e, f;
        return this.each(function(g, h) {
            e = k(p(b) ? a.Event(b) : b),
            e._args = d,
            e.target = h,
            a.each(c(h, b.type || b),
            function(a, b) {
                return f = b.proxy(e),
                e.isImmediatePropagationStopped() ? !1 : void 0
            })
        }),
        f
    },
    "focusin focusout load resize scroll unload click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select keydown keypress keyup error".split(" ").forEach(function(b) {
        a.fn[b] = function(a) {
            return a ? this.bind(b, a) : this.trigger(b)
        }
    }),
    ["focus", "blur"].forEach(function(b) {
        a.fn[b] = function(a) {
            return a ? this.bind(b, a) : this.each(function() {
                try {
                    this[b]()
                } catch(a) {}
            }),
            this
        }
    }),
    a.Event = function(a, b) {
        p(a) || (b = a, a = b.type);
        var c = document.createEvent(r[a] || "Events"),
        d = !0;
        if (b) for (var e in b)"bubbles" == e ? d = !!b[e] : c[e] = b[e];
        return c.initEvent(a, d, !0),
        j(c)
    }
} (Zepto),
function(a) {
    function b(b, c, d) {
        var e = a.Event(c);
        return a(b).trigger(e, d),
        !e.isDefaultPrevented()
    }
    function c(a, c, d, e) {
        return a.global ? b(c || s, d, e) : void 0
    }
    function d(b) {
        b.global && 0 === a.active++&&c(b, null, "ajaxStart")
    }
    function e(b) {
        b.global && !--a.active && c(b, null, "ajaxStop")
    }
    function f(a, b) {
        var d = b.context;
        return b.beforeSend.call(d, a, b) === !1 || c(b, d, "ajaxBeforeSend", [a, b]) === !1 ? !1 : (c(b, d, "ajaxSend", [a, b]), void 0)
    }
    function g(a, b, d, e) {
        var f = d.context,
        g = "success";
        d.success.call(f, a, g, b),
        e && e.resolveWith(f, [a, g, b]),
        c(d, f, "ajaxSuccess", [b, d, a]),
        i(g, b, d)
    }
    function h(a, b, d, e, f) {
        var g = e.context;
        e.error.call(g, d, b, a),
        f && f.rejectWith(g, [d, b, a]),
        c(e, g, "ajaxError", [d, e, a || b]),
        i(b, d, e)
    }
    function i(a, b, d) {
        var f = d.context;
        d.complete.call(f, b, a),
        c(d, f, "ajaxComplete", [b, d]),
        e(d)
    }
    function j() {}
    function k(a) {
        return a && (a = a.split(";", 2)[0]),
        a && (a == x ? "html": a == w ? "json": u.test(a) ? "script": v.test(a) && "xml") || "text"
    }
    function l(a, b) {
        return "" == b ? a: (a + "&" + b).replace(/[&?]{1,2}/, "?")
    }
    function m(b) {
        b.processData && b.data && "string" != a.type(b.data) && (b.data = a.param(b.data, b.traditional)),
        !b.data || b.type && "GET" != b.type.toUpperCase() || (b.url = l(b.url, b.data), b.data = void 0)
    }
    function n(b, c, d, e) {
        var f = !a.isFunction(c);
        return {
            url: b,
            data: f ? c: void 0,
            success: f ? a.isFunction(d) ? d: void 0 : c,
            dataType: f ? e || d: d
        }
    }
    function o(b, c, d, e) {
        var f, g = a.isArray(c),
        h = a.isPlainObject(c);
        a.each(c,
        function(c, i) {
            f = a.type(i),
            e && (c = d ? e: e + "[" + (h || "object" == f || "array" == f ? c: "") + "]"),
            !e && g ? b.add(i.name, i.value) : "array" == f || !d && "object" == f ? o(b, i, d, c) : b.add(c, i)
        })
    }
    var p, q, r = 0,
    s = window.document,
    t = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,
    u = /^(?:text|application)\/javascript/i,
    v = /^(?:text|application)\/xml/i,
    w = "application/json",
    x = "text/html",
    y = /^\s*$/;
    a.active = 0,
    a.ajaxJSONP = function(b, c) {
        if (! ("type" in b)) return a.ajax(b);
        var d, e, i = b.jsonpCallback,
        j = (a.isFunction(i) ? i() : i) || "jsonp" + ++r,
        k = s.createElement("script"),
        l = window[j],
        m = function(b) {
            a(k).triggerHandler("error", b || "abort")
        },
        n = {
            abort: m
        };
        return c && c.promise(n),
        a(k).on("load error",
        function(f, i) {
            clearTimeout(e),
            a(k).off().remove(),
            "error" != f.type && d ? g(d[0], n, b, c) : h(null, i || "error", n, b, c),
            window[j] = l,
            d && a.isFunction(l) && l(d[0]),
            l = d = void 0
        }),
        f(n, b) === !1 ? (m("abort"), n) : (window[j] = function() {
            d = arguments
        },
        k.src = b.url.replace(/=\?/, "=" + j), s.head.appendChild(k), b.timeout > 0 && (e = setTimeout(function() {
            m("timeout")
        },
        b.timeout)), n)
    },
    a.ajaxSettings = {
        type: "GET",
        beforeSend: j,
        success: j,
        error: j,
        complete: j,
        context: null,
        global: !0,
        xhr: function() {
            return new window.XMLHttpRequest
        },
        accepts: {
            script: "text/javascript, application/javascript, application/x-javascript",
            json: w,
            xml: "application/xml, text/xml",
            html: x,
            text: "text/plain"
        },
        crossDomain: !1,
        timeout: 0,
        processData: !0,
        cache: !0
    },
    a.ajax = function(b) {
        var c = a.extend({},
        b || {}),
        e = a.Deferred && a.Deferred();
        for (p in a.ajaxSettings) void 0 === c[p] && (c[p] = a.ajaxSettings[p]);
        d(c),
        c.crossDomain || (c.crossDomain = /^([\w-]+:)?\/\/([^\/]+)/.test(c.url) && RegExp.$2 != window.location.host),
        c.url || (c.url = window.location.toString()),
        m(c),
        c.cache === !1 && (c.url = l(c.url, "_=" + Date.now()));
        var i = c.dataType,
        n = /=\?/.test(c.url);
        if ("jsonp" == i || n) return n || (c.url = l(c.url, c.jsonp ? c.jsonp + "=?": c.jsonp === !1 ? "": "callback=?")),
        a.ajaxJSONP(c, e);
        var o, r = c.accepts[i],
        s = {},
        t = function(a, b) {
            s[a.toLowerCase()] = [a, b]
        },
        u = /^([\w-]+:)\/\//.test(c.url) ? RegExp.$1: window.location.protocol,
        v = c.xhr(),
        w = v.setRequestHeader;
        if (e && e.promise(v), c.crossDomain || t("X-Requested-With", "XMLHttpRequest"), t("Accept", r || "*/*"), (r = c.mimeType || r) && (r.indexOf(",") > -1 && (r = r.split(",", 2)[0]), v.overrideMimeType && v.overrideMimeType(r)), (c.contentType || c.contentType !== !1 && c.data && "GET" != c.type.toUpperCase()) && t("Content-Type", c.contentType || "application/x-www-form-urlencoded"), c.headers) for (q in c.headers) t(q, c.headers[q]);
        if (v.setRequestHeader = t, v.onreadystatechange = function() {
            if (4 == v.readyState) {
                v.onreadystatechange = j,
                clearTimeout(o);
                var b, d = !1;
                if (v.status >= 200 && v.status < 300 || 304 == v.status || 0 == v.status && "file:" == u) {
                    i = i || k(c.mimeType || v.getResponseHeader("content-type")),
                    b = v.responseText;
                    try {
                        "script" == i ? (1, eval)(b) : "xml" == i ? b = v.responseXML: "json" == i && (b = y.test(b) ? null: a.parseJSON(b))
                    } catch(f) {
                        d = f
                    }
                    d ? h(d, "parsererror", v, c, e) : g(b, v, c, e)
                } else h(v.statusText || null, v.status ? "error": "abort", v, c, e)
            }
        },
        f(v, c) === !1) return v.abort(),
        h(null, "abort", v, c, e),
        v;
        if (c.xhrFields) for (q in c.xhrFields) v[q] = c.xhrFields[q];
        var x = "async" in c ? c.async: !0;
        v.open(c.type, c.url, x, c.username, c.password);
        for (q in s) w.apply(v, s[q]);
        return c.timeout > 0 && (o = setTimeout(function() {
            v.onreadystatechange = j,
            v.abort(),
            h(null, "timeout", v, c, e)
        },
        c.timeout)),
        v.send(c.data ? c.data: null),
        v
    },
    a.get = function() {
        return a.ajax(n.apply(null, arguments))
    },
    a.post = function() {
        var b = n.apply(null, arguments);
        return b.type = "POST",
        a.ajax(b)
    },
    a.getJSON = function() {
        var b = n.apply(null, arguments);
        return b.dataType = "json",
        a.ajax(b)
    },
    a.fn.load = function(b, c, d) {
        if (!this.length) return this;
        var e, f = this,
        g = b.split(/\s/),
        h = n(b, c, d),
        i = h.success;
        return g.length > 1 && (h.url = g[0], e = g[1]),
        h.success = function(b) {
            f.html(e ? a("<div>").html(b.replace(t, "")).find(e) : b),
            i && i.apply(f, arguments)
        },
        a.ajax(h),
        this
    };
    var z = encodeURIComponent;
    a.param = function(a, b) {
        var c = [];
        return c.add = function(a, b) {
            this.push(z(a) + "=" + z(b))
        },
        o(c, a, b),
        c.join("&").replace(/%20/g, "+")
    }
} (Zepto),
function(a) {
    a.fn.serializeArray = function() {
        var b, c = [];
        return a([].slice.call(this.get(0).elements)).each(function() {
            b = a(this);
            var d = b.attr("type");
            "fieldset" != this.nodeName.toLowerCase() && !this.disabled && "submit" != d && "reset" != d && "button" != d && ("radio" != d && "checkbox" != d || this.checked) && c.push({
                name: b.attr("name"),
                value: b.val()
            })
        }),
        c
    },
    a.fn.serialize = function() {
        var a = [];
        return this.serializeArray().forEach(function(b) {
            a.push(encodeURIComponent(b.name) + "=" + encodeURIComponent(b.value))
        }),
        a.join("&")
    },
    a.fn.submit = function(b) {
        if (b) this.bind("submit", b);
        else if (this.length) {
            var c = a.Event("submit");
            this.eq(0).trigger(c),
            c.isDefaultPrevented() || this.get(0).submit()
        }
        return this
    }
} (Zepto),
function(a) {
    function b(b, d) {
        var i = b[h],
        j = i && e[i];
        if (void 0 === d) return j || c(b);
        if (j) {
            if (d in j) return j[d];
            var k = g(d);
            if (k in j) return j[k]
        }
        return f.call(a(b), d)
    }
    function c(b, c, f) {
        var i = b[h] || (b[h] = ++a.uuid),
        j = e[i] || (e[i] = d(b));
        return void 0 !== c && (j[g(c)] = f),
        j
    }
    function d(b) {
        var c = {};
        return a.each(b.attributes || i,
        function(b, d) {
            0 == d.name.indexOf("data-") && (c[g(d.name.replace("data-", ""))] = a.zepto.deserializeValue(d.value))
        }),
        c
    }
    var e = {},
    f = a.fn.data,
    g = a.camelCase,
    h = a.expando = "Zepto" + +new Date,
    i = [];
    a.fn.data = function(d, e) {
        return void 0 === e ? a.isPlainObject(d) ? this.each(function(b, e) {
            a.each(d,
            function(a, b) {
                c(e, a, b)
            })
        }) : 0 == this.length ? void 0 : b(this[0], d) : this.each(function() {
            c(this, d, e)
        })
    },
    a.fn.removeData = function(b) {
        return "string" == typeof b && (b = b.split(/\s+/)),
        this.each(function() {
            var c = this[h],
            d = c && e[c];
            d && a.each(b || d,
            function(a) {
                delete d[b ? g(this) : a]
            })
        })
    },
    ["remove", "empty"].forEach(function(b) {
        var c = a.fn[b];
        a.fn[b] = function() {
            var a = this.find("*");
            return "remove" === b && (a = a.add(this)),
            a.removeData(),
            c.call(this)
        }
    })
} (Zepto),
function(a) {
    function b(c) {
        var d = [["resolve", "done", a.Callbacks({
            once: 1,
            memory: 1
        }), "resolved"], ["reject", "fail", a.Callbacks({
            once: 1,
            memory: 1
        }), "rejected"], ["notify", "progress", a.Callbacks({
            memory: 1
        })]],
        e = "pending",
        f = {
            state: function() {
                return e
            },
            always: function() {
                return g.done(arguments).fail(arguments),
                this
            },
            then: function() {
                var c = arguments;
                return b(function(b) {
                    a.each(d,
                    function(d, e) {
                        var h = a.isFunction(c[d]) && c[d];
                        g[e[1]](function() {
                            var c = h && h.apply(this, arguments);
                            if (c && a.isFunction(c.promise)) c.promise().done(b.resolve).fail(b.reject).progress(b.notify);
                            else {
                                var d = this === f ? b.promise() : this,
                                g = h ? [c] : arguments;
                                b[e[0] + "With"](d, g)
                            }
                        })
                    }),
                    c = null
                }).promise()
            },
            promise: function(b) {
                return null != b ? a.extend(b, f) : f
            }
        },
        g = {};
        return a.each(d,
        function(a, b) {
            var c = b[2],
            h = b[3];
            f[b[1]] = c.add,
            h && c.add(function() {
                e = h
            },
            d[1 ^ a][2].disable, d[2][2].lock),
            g[b[0]] = function() {
                return g[b[0] + "With"](this === g ? f: this, arguments),
                this
            },
            g[b[0] + "With"] = c.fireWith
        }),
        f.promise(g),
        c && c.call(g, g),
        g
    }
    var c = Array.prototype.slice;
    a.when = function(d) {
        var e, f, g, h = c.call(arguments),
        i = h.length,
        j = 0,
        k = 1 !== i || d && a.isFunction(d.promise) ? i: 0,
        l = 1 === k ? d: b(),
        m = function(a, b, d) {
            return function(f) {
                b[a] = this,
                d[a] = arguments.length > 1 ? c.call(arguments) : f,
                d === e ? l.notifyWith(b, d) : --k || l.resolveWith(b, d)
            }
        };
        if (i > 1) for (e = new Array(i), f = new Array(i), g = new Array(i); i > j; ++j) h[j] && a.isFunction(h[j].promise) ? h[j].promise().done(m(j, g, h)).fail(l.reject).progress(m(j, f, e)) : --k;
        return k || l.resolveWith(g, h),
        l.promise()
    },
    a.Deferred = b
} (Zepto),
function(a) {
    a.Callbacks = function(b) {
        b = a.extend({},
        b);
        var c, d, e, f, g, h, i = [],
        j = !b.once && [],
        k = function(a) {
            for (c = b.memory && a, d = !0, h = f || 0, f = 0, g = i.length, e = !0; i && g > h; ++h) if (i[h].apply(a[0], a[1]) === !1 && b.stopOnFalse) {
                c = !1;
                break
            }
            e = !1,
            i && (j ? j.length && k(j.shift()) : c ? i.length = 0 : l.disable())
        },
        l = {
            add: function() {
                if (i) {
                    var d = i.length,
                    h = function(c) {
                        a.each(c,
                        function(a, c) {
                            "function" == typeof c ? b.unique && l.has(c) || i.push(c) : c && c.length && "string" != typeof c && h(c)
                        })
                    };
                    h(arguments),
                    e ? g = i.length: c && (f = d, k(c))
                }
                return this
            },
            remove: function() {
                return i && a.each(arguments,
                function(b, c) {
                    for (var d; (d = a.inArray(c, i, d)) > -1;) i.splice(d, 1),
                    e && (g >= d && --g, h >= d && --h)
                }),
                this
            },
            has: function(b) {
                return ! (!i || !(b ? a.inArray(b, i) > -1 : i.length))
            },
            empty: function() {
                return g = i.length = 0,
                this
            },
            disable: function() {
                return i = j = c = void 0,
                this
            },
            disabled: function() {
                return ! i
            },
            lock: function() {
                return j = void 0,
                c || l.disable(),
                this
            },
            locked: function() {
                return ! j
            },
            fireWith: function(a, b) {
                return ! i || d && !j || (b = b || [], b = [a, b.slice ? b.slice() : b], e ? j.push(b) : k(b)),
                this
            },
            fire: function() {
                return l.fireWith(this, arguments)
            },
            fired: function() {
                return !! d
            }
        };
        return l
    }
} (Zepto),
function(a) {
    function b(b) {
        return b = a(b),
        !(!b.width() && !b.height()) && "none" !== b.css("display")
    }
    function c(a, b) {
        a = a.replace(/=#\]/g, '="#"]');
        var c, d, e = h.exec(a);
        if (e && e[2] in g && (c = g[e[2]], d = e[3], a = e[1], d)) {
            var f = Number(d);
            d = isNaN(f) ? d.replace(/^["']|["']$/g, "") : f
        }
        return b(a, c, d)
    }
    var d = a.zepto,
    e = d.qsa,
    f = d.matches,
    g = a.expr[":"] = {
        visible: function() {
            return b(this) ? this: void 0
        },
        hidden: function() {
            return b(this) ? void 0 : this
        },
        selected: function() {
            return this.selected ? this: void 0
        },
        checked: function() {
            return this.checked ? this: void 0
        },
        parent: function() {
            return this.parentNode
        },
        first: function(a) {
            return 0 === a ? this: void 0
        },
        last: function(a, b) {
            return a === b.length - 1 ? this: void 0
        },
        eq: function(a, b, c) {
            return a === c ? this: void 0
        },
        contains: function(b, c, d) {
            return a(this).text().indexOf(d) > -1 ? this: void 0
        },
        has: function(a, b, c) {
            return d.qsa(this, c).length ? this: void 0
        }
    },
    h = new RegExp("(.*):(\\w+)(?:\\(([^)]+)\\))?$\\s*"),
    i = /^\s*>/,
    j = "Zepto" + +new Date;
    d.qsa = function(b, f) {
        return c(f,
        function(c, g, h) {
            try {
                var k; ! c && g ? c = "*": i.test(c) && (k = a(b).addClass(j), c = "." + j + " " + c);
                var l = e(b, c)
            } catch(m) {
                throw console.error("error performing selector: %o", f),
                m
            } finally {
                k && k.removeClass(j)
            }
            return g ? d.uniq(a.map(l,
            function(a, b) {
                return g.call(a, b, l, h)
            })) : l
        })
    },
    d.matches = function(a, b) {
        return c(b,
        function(b, c, d) {
            return ! (b && !f(a, b) || c && c.call(a, null, d) !== a)
        })
    }
} (Zepto),
~
function(a) {
    var b, c, d, e, f, g, h, i, j, k, l, m, n, o = [];
    b = {
        email: function(a) {
            return /^(?:[a-z0-9]+[_\-+.]?)*[a-z0-9]+@(?:([a-z0-9]+-?)*[a-z0-9]+.)+([a-z]{2,})+$/i.test(a)
        },
        date: function(a) {
            var b, c, d = /^([1-2]\d{3})([-/.]) ? (1[0 - 2] | 0 ? [1 - 9])([ - /.])?([1-2]\d|3[01]|0?[1-9])$/;
            return d.test(a) ? (b = d.exec(a), year = +b[1], month = +b[3] - 1, day = +b[5], c = new Date(year, month, day), year === c.getFullYear() && month === c.getMonth() && day === c.getDate()) : !1
        },
        mobile: function(a) {
            return /^1[3-9]\d{9}$/.test(a)
        },
        tel: function(a) {
            return /^(?:(?:0\d{2,3}[- ]?[1-9]\d{6,7})|(?:[48]00[- ]?[1-9]\d{6}))$/.test(a)
        },
        number: function(a) {
            var b = +this.$item.attr("min"),
            c = +this.$item.attr("max"),
            d = /^\-?(?:[1-9]\d*|0)(?:[.]\d+)?$/.test(a),
            a = +a,
            e = +this.$item.attr("step");
            return isNaN(b) && (b = a - 1),
            isNaN(c) && (c = a + 1),
            d && (isNaN(e) || 0 >= e ? a >= b && c >= a: 0 === (a + b) % e && a >= b && c >= a)
        },
        range: function(a) {
            return this.number(a)
        },
        url: function(a) {
            var b, c = "((https?|s?ftp|irc[6s]?|git|afp|telnet|smb):\\/\\/)?",
            d = "([a-z0-9]\\w*(\\:[\\S]+)?\\@)?",
            e = "(?:[a-z0-9]+(?:-[w]+)*.)*[a-z]{2,}",
            f = "(:\\d{1,5})?",
            g = "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}",
            h = "(\\/\\S*)?",
            i = [c, d, e, f, h],
            j = [c, d, g, f, h];
            return b = function(b) {
                return new RegExp("^" + b.join("") + "$", "i").test(a)
            },
            b(i) || b(j)
        },
        password: function(a) {
            return this.text(a)
        },
        checkbox: function() {
            return b._checker("checkbox")
        },
        radio: function() {
            return b._checker("radio")
        },
        _checker: function(b) {
            var c = this.$item.parents("form").eq(0),
            d = "input:" + b + '[name="' + this.$item.attr("name") + '"]',
            e = !1,
            f = a(d, c);
            return f.each(function(a, b) {
                return b.checked && !e ? e = !0 : void 0
            }),
            e
        },
        text: function(a) {
            var b = parseInt(this.$item.attr("maxlength"), 10);
            return notEmpty = function(a) {
                return !! a.length && !/^\s+$/.test(a)
            },
            isNaN(b) ? notEmpty(a) : notEmpty(a) && a.length <= b
        }
    },
    k = function(b, c, d) {
        var e = b.data(),
        f = e.url,
        g = e.method || "get",
        h = e.key || "key",
        i = l(b),
        j = {};
        j[h] = i,
        a[g](f, j).success(function(a) {
            var e = a ? "IM VALIDED": "unvalid";
            return n.call(this, b, c, d, e)
        }).error(function() {})
    },
    m = function(b, c, d) {
        var e = "a" === b.data("aorb") ? "b": "a",
        g = a("[data-aorb=" + e + "]", b.parents("form").eq(0)),
        h = [b, c, d],
        i = [g, c, d],
        j = 0;
        return j += n.apply(this, h) ? 0 : 1,
        j += n.apply(this, i) ? 0 : 1,
        j = j > 0 ? (f.apply(this, h), f.apply(this, i), !1) : n.apply(this, h.concat("unvalid"))
    },
    n = function(c, d, g, h) {
        if (!c) return "DONT VALIDATE UNEXIST ELEMENT";
        var i, j, k, m, n;
        return i = c.attr("pattern"),
        i && i.replace("\\", "\\\\"),
        j = c.attr("type") || "text",
        j = b[j] ? j: "text",
        k = a.trim(l(c)),
        n = c.data("event"),
        h = h ? h: i ? new RegExp(i).test(k) || "unvalid": b[j](k) || "unvalid",
        "unvalid" === h && f(c, d, g),
        /^(?:unvalid|empty)$/.test(h) ? (m = {
            $el: e.call(this, c, d, g, h),
            type: j,
            error: h
        },
        c.trigger("after:" + n, c), m) : (f.call(this, c, d, g), c.trigger("after:" + n, c), !1)
    },
    c = function(b, c) {
        return a(b, c)
    },
    l = function(a) {
        return a.val() || (a.is("[contenteditable]") ? a.text() : "")
    },
    validate = function(a, c, d) {
        var e, f, g, h, i, j;
        return b.$item = a,
        g = a.attr("type"),
        h = l(a),
        e = a.data("url"),
        f = a.data("aorb"),
        j = a.data("event"),
        i = [a, c, d],
        j && a.trigger("before:" + j, a),
        /^(?:radio|checkbox)$/.test(g) || f || b.text(h) ? f ? m.apply(this, i) : e ? k.apply(this, i) : n.call(this, a, c, d) : n.call(this, a, c, d, "empty")
    },
    i = function(b, c, d, e) {
        var f, g = /^radio|checkbox/;
        a.each(b,
        function(b, h) {
            a(h).on(g.test(h.type) || "SELECT" === h.tagName ? "change blur": c,
            function() {
                var b = a(this);
                g.test(this.type) && (b = a("input[type=" + this.type + "][name=" + this.name + "]", b.closest("form"))),
                b.each(function() { (f = validate.call(this, a(this), d, e)) && o.push(f)
                })
            })
        })
    },
    h = function(b, c, d, e) {
        return c && !i.length ? !0 : (o = a.map(b,
        function(b) {
            var c = validate.call(null, a(b), d, e);
            return c ? c: void 0
        }), i.length ? o: !1)
    },
    j = function(b) {
        var c, d;
        return (c = a.grep(o,
        function(a) {
            return a.$el = b
        })[0]) ? (d = a.inArray(c, o), o.splice(d, 1), o) : void 0
    },
    d = function(a, b) {
        return a.data("parent") ? a.closest(a.data("parent")) : b ? a.parent() : a
    },
    e = function(a, b, c, e) {
        return d(a, c).addClass(b + " " + e)
    },
    f = function(a, b, c) {
        return j.call(this, a),
        d(a, c).removeClass(b + " empty unvalid")
    },
    g = function(a) {
        return a.attr("novalidate") || a.attr("novalidate", "true")
    },
    a.fn.validator = function(b) {
        var d = this,
        b = b || {},
        e = b.identifie || "[required]",
        j = b.error || "error",
        k = b.isErrorOnParent || !1,
        l = b.method || "blur",
        m = b.before ||
        function() {
            return ! 0
        },
        n = b.after || function() {
            return ! 0
        },
        p = b.errorCallback || function() {},
        q = c(e, d);
        g(d), 
        l && i.call(this, q, l, j, k),
        d.on("focusin", e, function() {
            f.call(this, a(this), "error unvalid empty", k)
        }),
        d.on("submit", function(a) {
            return m.call(this, q),
            h.call(this, q, l, j, k),
            o.length ? (a.preventDefault(), p.call(this, o)) : n.call(this, a, q)
        })
    }
} (window.jQuery || window.Zepto),

function(a) {
    "use strict";
    var b = [],
    c = function() {
        for (var a = n(), c = 0; c < b.length; c++) try {
            var d = b[c],
            g = d[0],
            h = d[1],
            i = g.data("offset.lazy"),
            j = h.condition(g, i) && (0 != h.top || 0 != i.left);
            j && i.top + g.height() > a.top && i.top < a.bottom && (h.once && l(g), h.beforeLoad(g, h), e(d))
        } catch(k) {}
        f()
    },
    d = function(a) {
        for (var c = 0; c < b.length; c++) {
            var d = b[c];
            if (d && d[0].get(0) == a.get(0)) {
                d[1].once && l(d[0]),
                e(d);
                break
            }
        }
    },
    e = function(b) {
        var c = b[0],
        d = b[1];
        "image" == d.type ? !
        function(a, b) {
            setTimeout(function() {
                g(a, b)
            },
            0)
        } (c, d) : "url" == d.type ? !
        function(a, b) {
            setTimeout(function() {
                h(a, b)
            },
            0)
        } (c, d) : !
        function(b, c) {
            setTimeout(function() {
                c.onLoad.call(b.get(0), c.res(b), c),
                a(window).trigger("scroll")
            },
            0)
        } (c, d)
    },
    f = function() {
        var a = function(a, c) {
            for (var d = [], e = 0; e < b.length; e++) c(b[e], e, b) && d.push(b[e]);
            return d
        };
        b = a(b,
        function(a) {
            return !! a
        })
    },
    g = function(b, c) {
        var d = c.res(b);
        b.one({
            "load.__lazy": function(d) {
                c.onLoad.call(b.get(0), d, c),
                a(this).off(".lazy"),
                a(window).trigger("scroll")
            },
            "error.__lazy": function(d) {
                c.onError.call(b.get(0), d, c),
                a(this).off(".__lazy"),
                a(window).trigger("scroll")
            }
        });
        var e = b.get(0);
        null != d && "" != d ? (b.attr("src", d), e.complete || 4 === e.readyState ? b.trigger("load") : "uninitialized" === e.readyState && 0 === e.src.indexOf("data:") && b.trigger("error")) : b.trigger("error")
    },
    h = function(b, c) {
        a.ajax(c.res(b)).done(function(a) {
            c.onLoad.call(b.get(0), a, c)
        }).fail(function(a) {
            c.onError.call(b.get(0), a, c)
        }).always(function() {
            a(window).trigger("scroll")
        })
    },
    i = function() {
        for (var a = 0; a < b.length; a++) {
            var c = b[a];
            c &&
            function(a) {
                setTimeout(function() {
                    a[0].data("offset.lazy", a[1].offset(a[0]))
                },
                0)
            } (c)
        }
    },
    j = function() {
        i(),
        setTimeout(function() {
            a(window).trigger("scroll")
        },
        10)
    },
    k = function(c, d) {
        if (d || (d = {}), a.isFunction(d.offset) || (d.offset = function(a) {
            return a.offset()
        }), "img" == c.get(0).tagName.toLowerCase() && (d.type = "image"), d.condition || (d.condition = function() {
            return ! 0
        }), "image" == d.type && (d.once = !0, d.res || (d.res = c.data("src"))), !a.isFunction(d.res)) {
            var e = d.res;
            d.res = function() {
                return e
            }
        }
        c.data("offset.lazy", d.offset(c)),
        d.beforeLoad || (d.beforeLoad = function() {}),
        d.onLoad || (d.onLoad = function() {}),
        d.onError || (d.onError = function() {}),
        b.push([c, d])
    },
    l = function(a) {
        for (var c = 0; c < b.length; c++) {
            var d = b[c];
            if (d && d[0].get(0) == a.get(0)) {
                d[0].removeData("offset.lazy"),
                b[c] = null;
                break
            }
        }
    },
    m = function(a, b, c) {
        var d, e = null,
        f = 0;
        return function() {
            var g = new Date,
            h = b - (g - f);
            return c || (c = this),
            0 >= h && (clearTimeout(e), e = null, f = g, d = a.apply(c, arguments)),
            d
        }
    },
    n = function() {
        var b = a(window),
        c = b.scrollTop();
        return {
            top: c - a.lazy.sensitivity,
            bottom: c + b.height() + a.lazy.sensitivity
        }
    };
    a(window).on("scroll.__lazy", m(i, 100)),
    a(window).on("scroll.__lazy", m(c, 1)),
    a.fn.lazy = function(b) {
        return "destroy" === b ? this.each(function() {
            l(a(this))
        }) : "load" == b ? this.each(function() {
            d(a(this))
        }) : (this.each(function() {
            var c = a(this);
            setTimeout(function() {
                k(c, a.extend(!0, {},
                b))
            },
            0)
        }), setTimeout(function() {
            a(window).trigger("scroll")
        },
        100)),
        this
    },
    a.lazy = {
        refresh: j,
        sensitivity: 50
    }
} (Zepto),
function(a) {
    function b() {
        a("input").addClass("util-invisible")
    }
    function c() {
        a("input").removeClass("util-invisible")
    }
    a.fn.modal = function(d) {
        d && "show" != d ? "hide" == d ? (a(this).removeClass("open").trigger("hide"), c(), a("body").removeClass("modal-open")) : "toggle" == d ? a(this).modal(a(this).hasClass("open") ? "hide": "show") : "destroy" == d && (a(this).empty().remove().trigger("destroy"), a("body").removeClass("modal-open")) : (a(this).addClass("open").trigger("show"), b(), a("body").addClass("modal-open"))
    },
    a(document).on("click", '[data-toggle="modal"]',
    function(b) {
        b.preventDefault(),
        a("#" + a(this).data("target")).modal("show")
    }),
    a(document).on("click", '[data-dismiss="modal"]',
    function(b) {
        b.preventDefault(),
        a(this).parents(".modal").modal("hide")
    })
} (Zepto);

var onBridgeReady = function() {
    "undefined" != typeof WeixinJSBridge && (WeixinJSBridge.on("menu:share:appmessage",
    function() {
        return - 1 != dataForWeixin.link.indexOf("index/my") || -1 != dataForWeixin.link.indexOf("activity/my") ? (alert("���鵽����ϸҳ�桿����ת��..."), !1) : (WeixinJSBridge.invoke("sendAppMessage", {
            appid: dataForWeixin.appId,
            img_url: dataForWeixin.MsgImg,
            img_width: "120",
            img_height: "120",
            link: dataForWeixin.link,
            desc: dataForWeixin.desc,
            title: dataForWeixin.title
        },
        function() {
            dataForWeixin.callback()
        }), void 0)
    }), WeixinJSBridge.on("menu:share:timeline",
    function() {
        return - 1 != dataForWeixin.link.indexOf("index/my") || -1 != dataForWeixin.link.indexOf("activity/my") ? (alert("���鵽����ϸҳ�桿����ת��..."), !1) : (dataForWeixin.callback(), WeixinJSBridge.invoke("shareTimeline", {
            img_url: dataForWeixin.TLImg,
            img_width: "120",
            img_height: "120",
            link: dataForWeixin.link,
            desc: dataForWeixin.desc,
            title: dataForWeixin.title + " - " + dataForWeixin.desc
        },
        function() {}), void 0)
    }), WeixinJSBridge.on("menu:share:weibo",
    function() {
        WeixinJSBridge.invoke("shareWeibo", {
            content: "#Ⱥ��ͨѶ¼#" + dataForWeixin.title + "-" + dataForWeixin.desc + " " + dataForWeixin.link,
            url: dataForWeixin.link,
            img_url: dataForWeixin.MsgImg,
            pic: dataForWeixin.MsgImg,
            img: dataForWeixin.MsgImg
        },
        function() {
            dataForWeixin.callback()
        })
    }), WeixinJSBridge.on("menu:share:facebook", function() {
        dataForWeixin.callback(),
        WeixinJSBridge.invoke("shareFB", {
            img_url: dataForWeixin.TLImg,
            img_width: "120",
            img_height: "120",
            link: dataForWeixin.link,
            desc: dataForWeixin.desc,
            title: document.title
        },
        function() {})
    }))
};

document.addEventListener ? document.addEventListener("WeixinJSBridgeReady", onBridgeReady, !1) : document.attachEvent && (document.attachEvent("WeixinJSBridgeReady", onBridgeReady), document.attachEvent("onWeixinJSBridgeReady", onBridgeReady)),
document.addEventListener("WeixinJSBridgeReady",
function() {
    try {
        if ("undefined" == typeof WeixinJSBridge) return;
        WeixinJSBridge.call("hideToolbar")
    } catch(a) {}
}),
$(function() {
    "use strict";
    $(document).on("click", "[data-toggle]",
    function(a) {
        a.preventDefault()
    }),
    $(document).on("click", '[data-toggle="navbar"]',
    function() {
        $("#" + $(this).data("target")).toggleClass("open"),
        $(".navbar").toggleClass("active"),
        $(this).parent().find(".toggleTitle").toggle($(".navbar").hasClass("active"))
    }),
    $(".navbar-menu").on("click", "li",
    function(a) {
        a.stopPropagation()
    }),
    $(document).on("click", ".navbar-menu",
    function() {
        $('[data-toggle="navbar"]').click()
    }),
    $(document).on("focus", ".input-group input",
    function() {
        $(this).parents(".input-group").addClass("active")
    }),
    $(document).on("blur", ".input-group input",
    function() {
        $(this).parents(".input-group").removeClass("active")
    }),
    $(document).on("click", '[data-toggle="open"]',
    function() {
        $(this).toggleClass("active"),
        $("#" + $(this).data("target")).toggleClass("open")
    }),
    $(window).on("scroll", throttle(function() {
        $(this).scrollTop() >= $(window).height() / 2 ? $(".gotop").show() : $(".gotop").hide()
    },
    10)),
    $(".gotop").on("click",
    function() {
        $(window).scrollTop(0)
    }),
    $(document).on("click", ".accordion .accordion-hd",
    function(a) {
        a.preventDefault(),
        $(this).parent().toggleClass("open")//,
        //$.lazy.refresh()
    }),
    $(".select").each(function() {
        var a = $(this).find(".select-box"),
        b = $(this).find("option").filter(":selected");
        b.size() > 0 && a.text(b.text())
    }),
    $(document).on("change", ".select select",
    function() {
        var a = $(this).parents(".select"),
        b = a.find(".select-box"),
        c = $(this).find("option").filter(":selected");
        c.size() > 0 && b.text(c.text()),
        a.triggerHandler("change", $(this).val())
    }),
    $("input[type=radio]").each(function() {
        var a = $(this).parents(".radio");
        a.attr("radio", $(this).attr("name")),
        $(this).prop("checked") && a.addClass("checked")
    }),
    $(document).on("click", ".radio",
    function(a) {
        if (a.preventDefault(), !$(this).hasClass("checked")) {
            var b = $(this).attr("radio");
            $("[radio=" + b + "]").removeClass("checked"),
            $('input[type=radio][name="' + b + '"]').prop("checked", !1),
            $(this).addClass("checked"),
            $(this).find("input[type=radio]").prop("checked", !0).trigger("change")
        }
    }),
    $("input[type=checkbox]").filter(":checked").each(function() {
        $(this).parents(".checkbox").addClass("checked")
    }),
    $(document).on("click", ".checkbox",
    function(a) {
        a.preventDefault(),
        $(this).toggleClass("checked");
        var b = $(this).hasClass("checked");
        $(this).find("input[type=checkbox]").prop("checked", b).trigger("change")
    }),
    $(document).on("click", '[data-toggle="tab"]',
    function(a) {
        a.preventDefault(),
        $(this).parent().addClass("active").siblings().removeClass("active");
        var b = $($(this).attr("href"));
        b.size() > 0 && b.addClass("active").siblings().removeClass("active")
    }),
    $('form[data-validate="auto"]').each(function() {
        $(this).validator({
            isErrorOnParent: !0,
            errorCallback: function(a) {
                a.length > 0 && $(window).scrollTop(a[0].$el.offset().top - 50)
            },
            after: function() {
                $(this).find("[type=submit]").prop("disabled", !0)
            }
        })
    }),
    $(document).on("keydown", "input",
    function(a) {
        return 13 != a.which
    })
}),
function(a) {
    function b(a) {
        return Object.prototype.toString.call(a)
    }
    function c(a) {
        return "[object Object]" === b(a)
    }
    function d(a) {
        return "[object Function]" === b(a)
    }
    function e(a, b) {
        for (var c = 0,
        d = a.length; d > c && b.call(a, a[c], c) !== !1; c++);
    }
    function f(a) {
        if (!p.test(a)) return null;
        var b, c, d, e, f;
        if ( - 1 !== a.indexOf("trident/") && (b = /\btrident\/([0-9.]+)/.exec(a), b && b.length >= 2)) {
            d = b[1];
            var g = b[1].split(".");
            g[0] = parseInt(g[0], 10) + 4,
            f = g.join(".")
        }
        b = p.exec(a),
        e = b[1];
        var h = b[1].split(".");
        return "undefined" == typeof f && (f = e),
        h[0] = parseInt(h[0], 10) - 4,
        c = h.join("."),
        "undefined" == typeof d && (d = c),
        {
            browserVersion: f,
            browserMode: e,
            engineVersion: d,
            engineMode: c,
            compatible: d !== c
        }
    }
    function g(a) {
        if (o) try {
            var b = o.twGetRunPath.toLowerCase(),
            c = o.twGetSecurityID(window),
            d = o.twGetVersion(c);
            if (b && -1 === b.indexOf(a)) return ! 1;
            if (d) return {
                version: d
            }
        } catch(e) {}
    }
    function h(a, e, f) {
        var g = d(e) ? e.call(null, f) : e;
        if (!g) return null;
        var h = {
            name: a,
            version: k,
            codename: ""
        },
        i = b(g);
        if (g === !0) return h;
        if ("[object String]" === i) {
            if ( - 1 !== f.indexOf(g)) return h
        } else {
            if (c(g)) return g.hasOwnProperty("version") && (h.version = g.version),
            h;
            if (g.exec) {
                var j = g.exec(f);
                if (j) return h.version = j.length >= 2 && j[1] ? j[1].replace(/_/g, ".") : k,
                h
            }
        }
    }
    function i(a, b, c, d) {
        var f = u;
        e(b,
        function(b) {
            var c = h(b[0], b[1], a);
            return c ? (f = c, !1) : void 0
        }),
        c.call(d, f.name, f.version)
    }
    var j = {},
    k = "-1",
    l = navigator.userAgent || "",
    m = navigator.appVersion || "",
    n = navigator.vendor || "",
    o = window.external,
    p = /\b(?:msie |ie |trident\/[0-9].*rv[ :])([0-9.]+)/,
    q = [["nokia",
    function(a) {
        return - 1 !== a.indexOf("nokia ") ? /\bnokia ([0-9]+)?/: -1 !== a.indexOf("noain") ? /\bnoain ([a-z0-9]+)/: /\bnokia([a-z0-9]+)?/
    }], ["samsung",
    function(a) {
        return - 1 !== a.indexOf("samsung") ? /\bsamsung(?:\-gt)?[ \-]([a-z0-9\-]+)/: /\b(?:gt|sch)[ \-]([a-z0-9\-]+)/
    }], ["wp",
    function(a) {
        return - 1 !== a.indexOf("windows phone ") || -1 !== a.indexOf("xblwp") || -1 !== a.indexOf("zunewp") || -1 !== a.indexOf("windows ce")
    }], ["pc", "windows"], ["ipad", "ipad"], ["ipod", "ipod"], ["iphone", /\biphone\b|\biph(\d)/], ["mac", "macintosh"], ["mi", /\bmi[ \-]?([a-z0-9 ]+(?= build))/], ["aliyun", /\baliyunos\b(?:[\-](\d+))?/], ["meizu", /\b(?:meizu\/|m)([0-9]+)\b/], ["nexus", /\bnexus ([0-9s.]+)/], ["huawei",
    function(a) {
        return - 1 !== a.indexOf("huawei-huawei") ? /\bhuawei\-huawei\-([a-z0-9\-]+)/: /\bhuawei[ _\-]?([a-z0-9]+)/
    }], ["lenovo",
    function(a) {
        return - 1 !== a.indexOf("lenovo-lenovo") ? /\blenovo\-lenovo[ \-]([a-z0-9]+)/: /\blenovo[ \-]?([a-z0-9]+)/
    }], ["zte",
    function(a) {
        return /\bzte\-[tu]/.test(a) ? /\bzte-[tu][ _\-]?([a-su-z0-9\+]+)/: /\bzte[ _\-]?([a-su-z0-9\+]+)/
    }], ["vivo", /\bvivo ([a-z0-9]+)/], ["htc",
    function(a) {
        return /\bhtc[a-z0-9 _\-]+(?= build\b)/.test(a) ? /\bhtc[ _\-]?([a-z0-9 ]+(?= build))/: /\bhtc[ _\-]?([a-z0-9 ]+)/
    }], ["oppo", /\boppo[_]([a-z0-9]+)/], ["konka", /\bkonka[_\-]([a-z0-9]+)/], ["sonyericsson", /\bmt([a-z0-9]+)/], ["coolpad", /\bcoolpad[_ ]?([a-z0-9]+)/], ["lg", /\blg[\-]([a-z0-9]+)/], ["android", "android"], ["blackberry", "blackberry"]],
    r = [["wp",
    function(a) {
        return - 1 !== a.indexOf("windows phone ") ? /\bwindows phone (?:os )?([0-9.]+)/: -1 !== a.indexOf("xblwp") ? /\bxblwp([0-9.]+)/: -1 !== a.indexOf("zunewp") ? /\bzunewp([0-9.]+)/: "windows phone"
    }], ["windows", /\bwindows nt ([0-9.]+)/], ["macosx", /\bmac os x ([0-9._]+)/], ["ios",
    function(a) {
        return /\bcpu(?: iphone)? os /.test(a) ? /\bcpu(?: iphone)? os ([0-9._]+)/: -1 !== a.indexOf("iph os ") ? /\biph os ([0-9_]+)/: /\bios\b/
    }], ["yunos", /\baliyunos ([0-9.]+)/], ["android", /\bandroid[\/\- ]?([0-9.x]+)?/], ["chromeos", /\bcros i686 ([0-9.]+)/], ["linux", "linux"], ["windowsce", /\bwindows ce(?: ([0-9.]+))?/], ["symbian", /\bsymbian(?:os)?\/([0-9.]+)/], ["meego", /\bmeego\b/], ["blackberry", "blackberry"]],
    s = [["trident", p], ["webkit", /\bapplewebkit[\/]?([0-9.+]+)/], ["gecko", /\bgecko\/(\d+)/], ["presto", /\bpresto\/([0-9.]+)/], ["androidwebkit", /\bandroidwebkit\/([0-9.]+)/], ["coolpadwebkit", /\bcoolpadwebkit\/([0-9.]+)/]],
    t = [["sg", / se ([0-9.x]+)/], ["tw",
    function() {
        var a = g("theworld");
        return "undefined" != typeof a ? a: "theworld"
    }], ["360",
    function(a) {
        var b = g("360se");
        return "undefined" != typeof b ? b: -1 !== a.indexOf("360 aphone browser") ? /\b360 aphone browser \(([^\)]+)\)/: /\b360(?:se|ee|chrome|browser)\b/
    }], ["mx",
    function() {
        try {
            if (o && (o.mxVersion || o.max_version)) return {
                version: o.mxVersion || o.max_version
            }
        } catch(a) {}
        return /\bmaxthon(?:[ \/]([0-9.]+))?/
    }], ["qq", /\bm?qqbrowser\/([0-9.]+)/], ["green", "greenbrowser"], ["tt", /\btencenttraveler ([0-9.]+)/], ["lb",
    function(a) {
        if ( - 1 === a.indexOf("lbbrowser")) return ! 1;
        var b;
        try {
            o && o.LiebaoGetVersion && (b = o.LiebaoGetVersion())
        } catch(c) {}
        return {
            version: b || k
        }
    }], ["tao", /\btaobrowser\/([0-9.]+)/], ["fs", /\bcoolnovo\/([0-9.]+)/], ["sy", "saayaa"], ["baidu", /\bbidubrowser[ \/]([0-9.x]+)/], ["ie", p], ["mi", /\bmiuibrowser\/([0-9.]+)/], ["opera",
    function(a) {
        var b = /\bopera.+version\/([0-9.ab]+)/,
        c = /\bopr\/([0-9.]+)/;
        return b.test(a) ? b: c
    }], ["chrome", / (?:chrome|crios|crmo)\/([0-9.]+)/], ["uc",
    function(a) {
        return a.indexOf("ucbrowser/") >= 0 ? /\bucbrowser\/([0-9.]+)/: /\buc\/[0-9]/.test(a) ? /\buc\/([0-9.]+)/: a.indexOf("ucweb") >= 0 ? /\bucweb[\/]?([0-9.]+)?/: /\b(?:ucbrowser|uc)\b/
    }], ["android",
    function(a) {
        return - 1 !== a.indexOf("android") ? /\bversion\/([0-9.]+(?: beta)?)/: void 0
    }], ["safari", /\bversion\/([0-9.]+(?: beta)?)(?: mobile(?:\/[a-z0-9]+)?)? safari\//], ["webview", /\bcpu(?: iphone)? os (?:[0-9._]+).+\bapplewebkit\b/], ["firefox", /\bfirefox\/([0-9.ab]+)/], ["nokia", /\bnokiabrowser\/([0-9.]+)/]],
    u = {
        name: "na",
        version: k
    },
    v = function(a) {
        a = (a || "").toLowerCase();
        var b = {};
        i(a, q,
        function(a, c) {
            var d = parseFloat(c);
            b.device = {
                name: a,
                version: d,
                fullVersion: c
            },
            b.device[a] = d
        },
        b),
        i(a, r,
        function(a, c) {
            var d = parseFloat(c);
            b.os = {
                name: a,
                version: d,
                fullVersion: c
            },
            b.os[a] = d
        },
        b);
        var c = f(a);
        return i(a, s,
        function(a, d) {
            var e = d;
            c && (d = c.engineVersion || c.engineMode, e = c.engineMode);
            var f = parseFloat(d);
            b.engine = {
                name: a,
                version: f,
                fullVersion: d,
                mode: parseFloat(e),
                fullMode: e,
                compatible: c ? c.compatible: !1
            },
            b.engine[a] = f
        },
        b),
        i(a, t,
        function(a, d) {
            var e = d;
            c && ("ie" === a && (d = c.browserVersion), e = c.browserMode);
            var f = parseFloat(d);
            b.browser = {
                name: a,
                version: f,
                fullVersion: d,
                mode: parseFloat(e),
                fullMode: e,
                compatible: c ? c.compatible: !1
            },
            b.browser[a] = f
        },
        b),
        b
    };
    j = v(l + " " + m + " " + n),
    j.parse = v,
    a.detector = j
} (window),
function(a) {
    function b(a, b, d, e, f) {
        return ! f && arguments.callee.caller && (f = c(arguments.callee.caller)),
        {
            msg: a || "",
            file: b || "",
            line: d || 0,
            num: e || "",
            stack: f || "",
            detector: {
                browser: detector.browser,
                device: detector.device,
                engine: detector.engine,
                os: detector.os
            }
        }
    }
    function c(a) {
        for (var b = []; a.arguments && a.arguments.callee && a.arguments.callee.caller && (a = a.arguments.callee.caller, b.push("at " + d(a)), a.caller !== a););
        return b.join("\n")
    }
    function d(a) {
        var b = String(a).match(/^function\b[^\)]+\)/);
        return b ? b[0] : ""
    }
    function e(a) {
        return a instanceof Error || "[object Error]" != Object.prototype.toString.call(a)
    }
    function f() {
        var a = +new Date;
        return a.toString().substring(0, 10)
    }
    var g = a.monitor = {},
    h = [],
    i = [];
    a.onerror = function() {
        var c = arguments,
        d = f();
        c = b.apply(null, c),
        c.date = d,
        c.url = location.href,
        c.top = $(a).scrollTop(),
        i.push(c),
        h.forEach(function(a) {
            a.call(null, c)
        })
    },
    g.error = function(c) {
        if (e(c)) {
            var d = c.stack || c.stacktrace,
            g = b(c.message || c.description, c.fileName, c.lineNumber || c.line, c.number, d);
            g.date = f(),
            g.url = location.href,
            g.top = $(a).scrollTop(),
            i.push(g)
        }
    },
    g.addListener = function(a) {
        h.push(a)
    },
    g.report = function(a, b) {
        100 >= b && (b = 100),
        setInterval(function() {
            if (i.length > 0) {
                try {
                    a(i)
                } catch(b) {}
                i = []
            }
        },
        b)
    },
    g.report(function(a) {
        "Uncaught ReferenceError: WeixinJSBridge is not defined" != $.trim(a.msg) && $.post("/api/feedback/send", {
            message: JSON.stringify(a)
        })
    },
    1e3)
} (window),
Pager.prototype = {
    init: function() {
        this.$monitor.on("click",
        function(a) {
            a.preventDefault()
        })
    },
    initClick: function() {
        var a = this;
        this.$monitor.on("click",
        function() {
            a.allowAccess() && (a.nextRequest(), a._pause = !1, a._lazyCount = 0)
        })
    },
    initLazyLoad: function() {
        this.initClick();
        var a = this;
        this.$monitor.lazy({
            type: "url",
            res: function() {
                return {
                    url: a.nextUrl,
                    dataType: "json"
                }
            },
            beforeLoad: function() {
                a._lazyCount++,
                a.status("loading")
            },
            onLoad: function(b) {
                a.requestAfter(b),
                a._stop && a.$monitor.lazy("destroy"),
                a.pauseInterval > 0 && a._lazyCount >= a.pauseInterval && (a._pause = !0)
            },
            onError: function() {
                a.status("error"),
                a.errorCallback.apply(a, arguments)
            },
            condition: function() {
                return ! a._pause && a.allowAccess()
            }
        })
    },
    requestAfter: function(a) {
        a && void 0 != a.html ? (this.$container.append($.trim(a.html)), a.next ? (this.nextUrl = a.next, this.status("wait")) : this.end(), this.imgLazyLoad(), this.loadCallback.apply(this, arguments)) : (this.status("error"), this.errorCallback.apply(this, arguments))
    },
    nextRequest: function() {
        this.status("loading");
        var a = this,
        b = $.getJSON(this.nextUrl);
        b.done($.proxy(this.requestAfter, this)),
        b.fail(function() {
            a.status("error"),
            a.errorCallback.apply(a, arguments)
        })
    },
    imgLazyLoad: function() {
        this.$container.find("img.lazy").removeClass("lazy").lazy()
    },
    end: function() {
        this._stop = !0,
        this.status("disabled")
    },
    allowAccess: function() {
        return ! this._stop && "wait" == this.$monitor.data("status") || "error" == this.$monitor.data("status")
    },
    status: function(a) {
        this.$monitor.data("status", a).attr("data-status", a)
    }
},
Pager.prototype.constructor = Pager,
Comment.TPL = {
    REPLYBOX: '<div data-modal="alert" class="modal" >\n	<div class="modal-container">\n		<form method="post">\n			<div class="form-group">\n				<textarea name="content" required id="content" rows="3" class="form-control" placeholder="��������"></textarea>\n				<div class="help-block empty">����д�ظ�����</div>\n			</div>\n			<div class="form-group">\n				<button type="submit" class="btn btn-block">�ύ</button>\n			</div>\n		</form>\n		<div class="actions">\n			<a href="#" class="btn btn-block btn-default" data-dismiss="modal">�رմ���</a>\n		</div>\n	</div>\n</div>',
    CONTAINER: '<div class="wrapper"><a class="btn btn-block mainReply" href="#">��������</a></div>\n<div class="list-comment"></div>\n<a data-status="wait" class="more listview-tips-more2">\n	<span class="tips-wait"><b class="icon icon-arrow-down"></b>�����ʾ���</span>\n	<span class="tips-loading">������</span>\n	<span class="tips-error">���緱æ���������¼���</span>\n</a>'
},
Comment.prototype = {
    pushComment: function(a, b) {
        var c = $.Deferred(),
        d = $.post("/comment/add", {
            code: this.opts.code,
            parent_id: a,
            content: b
        },
        null, "json");
        return d.done(function(a) {
            a.status ? c.resolve(a.info) : c.reject({
                error: a.info
            })
        }),
        d.fail(function() {
            c.reject({
                error: "���۱���ʧ�ܣ�������"
            })
        }),
        c.promise()
    },
    addComment: function(a) {
        var b = this.createHtml(a);
        this.$element.find(".list-comment").prepend(b)
    },
    removeComment: function(a) {
        var b = $.Deferred(),
        c = $.post("/comment/remove", {
            code: this.opts.code,
            id: a
        },
        null, "json");
        return c.done(function(a) {
            a.status ? b.resolve(a.info) : b.reject({
                error: a.info
            })
        }),
        c.fail(function() {
            b.reject({
                error: "����ɾ��ʧ�ܣ�������"
            })
        }),
        b.promise()
    },
    initPager: function() {
        new Pager({
            monitor: this.$element.find(".more"),
            nextUrl: "/comment/view/code/" + this.opts.code,
            container: this.$element.find(".list-comment"),
            pauseInterval: 3
        })
    },
    createDOM: function() {
        this.$element = $("<div />", {
            "class": "box-comments"
        }),
        this.$element.html(Comment.TPL.CONTAINER),
        this.$element.appendTo(this.$container)
    },
    openReplyBox: function(a) {
        var b = this,
        c = $(Comment.TPL.REPLYBOX);
        c.find("form").validator({
            isErrorOnParent: !0,
            after: function() {
                c.find(".actions .btn").addClass("disabled"),
                c.find("[type=submit]").prop("disabled", !0);
                var d = b.pushComment(a || 0, $(this).find("textarea").val());
                return d.always(function() {
                    c.find(".actions .btn").removeClass("disabled"),
                    c.find("[type=submit]").prop("disabled", !1)
                }),
                d.done(function(a) {
                    c.modal("destroy"),
                    b.addComment(a)
                }),
                d.fail(function(a) {
                    alert(a.error)
                }),
                !1
            }
        }),
        c.appendTo("body"),
        c.modal("show")
    },
    checkLogin: function() {
        return this.user ? !0 : (confirm("��û�е�¼���Ƿ�����ǰ���¼��") && (location.href = "/oauth/login?return=" + encodeURIComponent(location.href)), !1)
    },
    bindEvent: function() {
        var a = this;
        this.$element.on("click", ".mainReply",
        function(b) {
            b.preventDefault(),
            a.checkLogin() && a.openReplyBox()
        }),
        this.$element.on("click", ".delete",
        function(b) {
            if (b.preventDefault(), a.checkLogin() && !$(this).hasClass("disabled") && confirm("ȷ��ɾ������ۣ�")) {
                $(this).addClass("disabled");
                var c = $(this).parents(".item");
                a.removeComment(c.data("id")),
                c.remove()
            }
        }),
        this.$element.on("click", ".reply",
        function(b) {
            b.preventDefault(),
            a.checkLogin() && a.openReplyBox($(this).parents(".item").data("id"))
        })
    },
    createHtml: function(a) {
        return a
    }
},
Comment.prototype.constructor = Comment,
$(function(a) {
    function b() {
        var b = a('input[name="phonebook_id"]:checked').val(); - 1 == b ? (a("#phonebook-form").show(), a("#phonebook-btn").hide()) : (a("#phonebook-form").hide(), a("#phonebook-btn").show())
    }
    function c() {
        var b = navigator.geolocation;
        b && b.getCurrentPosition(function(b) {
            if (b) {
                var c = b.coords.latitude,
                e = b.coords.longitude;
                a("#latitude").val(c),
                a("#longitude").val(e),
                a.get("/index/geocoder", {
                    latitude: c,
                    longitude: e
                },
                function(b) {
                    if (b && b.formatted_address) {
                        var c = a('input[auto-address="true"][value=""]');
                        c.each(function() {
                            "" == a(this).val() && b.formatted_address && a(this).val(b.formatted_address)
                        })
                    }
                },
                "json")
            } else d()
        },
        function() {
            d()
        },
        {
            maximumAge: 1e3
        })
    }
    function d() {
       
    }
    function e(b) {
        var c, d, e = b.find("input"),
        g = a("#list-search"),
        h = b.parent().find(".view-list, .view-more"),
        k = function(a) {
            a && (h.addClass("util-hide"), g.removeClass("util-hide"), g.find("img").lazy("destroy"), g.empty().html('<div class="alert alert-warning wrapper text-center">' + a + "</div>"))
        },
        l = function(a) {
            h.addClass("util-hide"),
            g.find("img").lazy("destroy"),
            g.removeClass("util-hide").empty().html(a),
            g.find("img.lazy").removeClass("lazy").lazy()
        };
        e.on("input",
        function() {
            c && c.reject(),
            d && clearTimeout(d);
            var e = a(this).attr("name"),
            i = a.trim(a(this).val());
            "" != i ? d = setTimeout(function() {
                c = a.Deferred(),
                f(b.attr("action"), [{
                    name: e,
                    value: i
                }], c),
                c.done(l).fail(k)
            },
            100) : (g.empty().addClass("util-hide"), h.removeClass("util-hide"))
        }),
        e.on("focus",
        function() {
            i();
            var b = a(this).offset().top;
            setTimeout(function() {
                a(window).scrollTop(b - 50)
            },
            800)
        }),
        e.on("blur", j)
    }
    function f(b, c, d) {
        var e = a.getJSON(b, c);
        return e.done(function(b) {
            b && "" != a.trim(b.html) ? d.resolve(b.html) : d.reject("�Ҳ�������")
        }),
        e.fail(function() {
            d.reject("���緱æ")
        }),
        d
    }
    function g() {
        m.each(function() {
            var b = {
                date: {
                    preset: "date",
                    dateOrder: "yymmdd",
                    dateFormat: "yy-mm-dd"
                },
                datetime: {
                    preset: "datetime",
                    dateOrder: "yymmdd",
                    dateFormat: "yy-mm-dd",
                    timeFormat: "HH:ii"
                },
                time: {
                    preset: "time",
                    timeFormat: "hh:ii"
                }
            },
            c = a(this).attr("type");
            a(this).attr("type", "text").scroller(a.extend(b[c], {
                lang: "zh"
            }))
        })
    }
    function h() {}
    function i() {
        a("#site-nav").addClass("util-invisible")
    }
    function j() {
        a("#site-nav").removeClass("util-invisible")
    }
    function k() {
       
    }
    if (a(".listview-hide-show").on("click",
    function() {
        return a(".listview-hide-show").hide(),
        a(".listview-hide").show(),
        setTimeout(function() {
            a.lazy.refresh()
        },
        1e3),
        !1
    }), a("img.avatarimg").one("error",
    function() {
        a(this).attr("src", "/Public/image/avatar.jpg")
    }), a(document).on("click", '[data-rel="popup"]',
    function() {
        var b = a(this).attr("href");
        if (b) return a(b).modal("show"),
        !1
    }), a(document).on("click", 'div[data-show="showCard"]',
    function() {
        var b = a(this).parent().find(".show"),
        c = a(this),
        d = a(this).attr("href");
        if (!d) return ! 1;
        if (b[0]) return h(b),
        b.toggle(),
        !1;
        b = a('<div class="show">������...</div>'),
        c.after(b);
        var d = a(this).attr("href");
        return a.get(d,
        function(c) {
            c = a("<div>" + c + "</div>");
            var d = c.find(".card-info").html(),
            e = c.find(".control-bar").html();
            b.html(d + e),
            h(b)
        }),
        !1
    }), a("#phonebook-select").find(".radio").size() > 0 && (b(), a("#phonebook-select").change(function() {
        b()
    })), a(document).on("click", '[data-action="setRole"]',
    function() {
        var b = a(this).attr("openid"),
        c = a(this).attr("code"),
        d = a(this).attr("role");
        return b ? (confirm("�Ƿ�ȷ�����ô��û���") && a.ajax({
            type: "POST",
            url: "/index/setrole",
            dataType: "json",
            data: {
                openid: b,
                code: c,
                role: d
            },
            success: function(a) {
                alert(a.info),
                a.status && window.location.reload()
            }
        }), !1) : void 0
    }), a('input[auto-address="true"]')[0]) {
        var l = a('input[auto-address="true"][value=""]');
        if (!l) return;
        setTimeout(c, 3e3)
    }
    a(document).on("click", '[data-action="save-to-phone"]',
    function() {
        if (window.onapp) {
            var b = a(this).attr("data-card-id"),
            c = window.cards[b];
            c && callApp("savePhoneBook", c)
        }
        return ! 1
    }),
    a(document).on("click", '[data-action="share"]',
    function() {
        if (window.onapp) return callApp("share", JSON.stringify(window.dataForWeixin)),
        !1;
        if (!a(".share-popup")[0]) {
            var b = a('<div class="share-popup"><img src="/Public/image/share.png" class="popphoto" alt=""></div>');
            a("body").append(b)
        }
        return a(".share-popup").show(),
        a(".share-popup").one("click",
        function() {
            a(".share-popup").hide()
        }),
        !1
    }),
    a(document).on("click", '[data-action="brower-popup"]',
    function() {
        if (window.onapp) return ! 1;
        if (!a(".share-popup")[0]) {
            var b = a('<div class="share-popup"><img src="/Public/image/brower.png" class="popphoto" alt=""></div>');
            a("body").append(b)
        }
        return a(".share-popup").show(),
        a(".share-popup").one("click",
        function() {
            a(".share-popup").hide()
        }),
        !1
    }),
    a(".view-search").each(function() {
        a(this).on("submit", !1),
        e(a(this))
    });
    var m = a("[type=date], [type=datetime], [type=time]");
    return yepnope({
        test: m.size() > 0,
        yep: ["/Public/lib/mobiscroll.js", "/Public/lib/mobiscroll.css"],
        complete: g
    }),
    h(a("body")),
    k(),
    a(document).on("click", '[data-action="addFriend"]', function() {
        var b = a(this).attr("openid"),
        c = a(this);
        return confirm("ȷ����TA������Ƭ��") ? (c.html('<p style="text-align: center">������...</p>'), b && a.ajax({
            type: "POST",
            url: "/card/add",
            dataType: "json",
            data: {
                id: b
            },
            success: function(a) {
                c.after('<p style="text-align: center">' + a.info + "</p>").remove(),
                0 == a.status && (alert(a.info), a.url && (window.location.href = a.url))
            }
        }), !1) : !1
    }),
    !window.openid && window.onapp ? (callApp("webNotSign", ""), !1) : void 0
});