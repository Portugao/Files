CKEDITOR.plugins.add('MUFiles', {
    requires: 'popup',
    lang: 'en,nl,de',
    init: function (editor) {
        editor.addCommand('insertMUFiles', {
            exec: function (editor) {
                var url = Zikula.Config.baseURL + Zikula.Config.entrypoint + '?module=MUFiles&type=external&func=finder&editor=ckeditor';
                // call method in MUFiles_Finder.js and also give current editor
                MUFilesFinderCKEditor(editor, url);
            }
        });
        editor.ui.addButton('mufiles', {
            label: 'Insert MUFiles object',
            command: 'insertMUFiles',
         // icon: this.path + 'images/ed_mufiles.png'
            icon: '/images/icons/extrasmall/favorites.png'
        });
    }
});
