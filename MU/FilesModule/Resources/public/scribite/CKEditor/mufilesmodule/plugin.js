CKEDITOR.plugins.add('mufilesmodule', {
    requires: 'popup',
    init: function (editor) {
        editor.addCommand('insertMUFilesModule', {
            exec: function (editor) {
                MUFilesModuleFinderOpenPopup(editor, 'ckeditor');
            }
        });
        editor.ui.addButton('mufilesmodule', {
            label: 'Files',
            command: 'insertMUFilesModule',
            icon: this.path.replace('scribite/CKEditor/mufilesmodule', 'images') + 'admin.png'
        });
    }
});
