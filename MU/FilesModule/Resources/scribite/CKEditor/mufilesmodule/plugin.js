CKEDITOR.plugins.add('mufilesmodule', {
    requires: 'popup',
    lang: 'en,nl,de',
    init: function (editor) {
        editor.addCommand('insertMUFilesModule', {
            exec: function (editor) {
                var url = Routing.generate('mufilesmodule_external_finder', { objectType: 'collection', editor: 'ckeditor' });
                // call method in MUFilesModule.Finder.js and provide current editor
                MUFilesModuleFinderCKEditor(editor, url);
            }
        });
        editor.ui.addButton('mufilesmodule', {
            label: editor.lang.mufilesmodule.title,
            command: 'insertMUFilesModule',
            icon: this.path.replace('scribite/CKEditor/mufilesmodule', 'public/images') + 'admin.png'
        });
    }
});
