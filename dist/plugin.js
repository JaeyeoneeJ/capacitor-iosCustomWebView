var capacitorCustomWebView = (function (exports, core) {
    'use strict';

    const CustomWebView = core.registerPlugin('CustomWebView', {
        web: () => Promise.resolve().then(function () { return web; }).then((m) => new m.CustomWebViewWeb()),
    });

    class CustomWebViewWeb extends core.WebPlugin {
        async open(options) {
            console.warn('[CustomWebView] open() is not supported on web', options);
        }
        async close() {
            console.warn('[CustomWebView] close() is not supported on web');
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        CustomWebViewWeb: CustomWebViewWeb
    });

    exports.CustomWebView = CustomWebView;

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
