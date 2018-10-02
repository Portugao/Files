var mufilesmodule = function(quill, options) {
    setTimeout(function() {
        var button;

        button = jQuery('button[value=mufilesmodule]');

        button
            .css('background', 'url(' + Zikula.Config.baseURL + Zikula.Config.baseURI + '/web/modules/mufiles/images/admin.png) no-repeat center center transparent')
            .css('background-size', '16px 16px')
            .attr('title', 'Files')
        ;

        button.click(function() {
            MUFilesModuleFinderOpenPopup(quill, 'quill');
        });
    }, 1000);
};
