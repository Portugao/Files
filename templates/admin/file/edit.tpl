{* purpose of this template: build the Form to edit an instance of file *}
{include file='admin/header.tpl'}
{pageaddvar name='javascript' value='modules/MUFiles/javascript/MUFiles_editFunctions.js'}
{pageaddvar name='javascript' value='modules/MUFiles/javascript/MUFiles_validation.js'}

{if $mode eq 'edit'}
    {gt text='Edit file' assign='templateTitle'}
    {assign var='adminPageIcon' value='edit'}
{elseif $mode eq 'create'}
    {gt text='Create file' assign='templateTitle'}
    {assign var='adminPageIcon' value='new'}
{else}
    {gt text='Edit file' assign='templateTitle'}
    {assign var='adminPageIcon' value='edit'}
{/if}
<div class="mufiles-file mufiles-edit">
    {pagesetvar name='title' value=$templateTitle}
    <div class="z-admin-content-pagetitle">
        {icon type=$adminPageIcon size='small' alt=$templateTitle}
        <h3>{$templateTitle}</h3>
    </div>
{form enctype='multipart/form-data' cssClass='z-form'}
    {* add validation summary and a <div> element for styling the form *}
    {mufilesFormFrame}
    {formsetinitialfocus inputId='title'}

    <fieldset>
        <legend>{gt text='Content'}</legend>
        
        <div class="z-formrow">
            {formlabel for='title' __text='Title' mandatorysym='1' cssClass=''}
            {formtextinput group='file' id='title' mandatory=true readOnly=false __title='Enter the title of the file' textMode='singleline' maxLength=255 cssClass='required' }
            {mufilesValidationError id='title' class='required'}
        </div>
        
        <div class="z-formrow">
            {formlabel for='description' __text='Description' cssClass=''}
            {formtextinput group='file' id='description' mandatory=false __title='Enter the description of the file' textMode='multiline' rows='6' cols='50' cssClass='' }
        </div>
        
        <div class="z-formrow">
            {assign var='mandatorySym' value='1'}
            {if $mode ne 'create'}
                {assign var='mandatorySym' value='0'}
            {/if}
            {formlabel for='uploadFile' __text='Upload file' mandatorysym=$mandatorySym cssClass=''}<br />{* break required for Google Chrome *}
            {if $mode eq 'create'}
                {formuploadinput group='file' id='uploadFile' mandatory=true readOnly=false cssClass='required validate-upload' }
            {else}
                {formuploadinput group='file' id='uploadFile' mandatory=false readOnly=false cssClass=' validate-upload' }
                <span class="z-formnote"><a id="resetUploadFileVal" href="javascript:void(0);" class="z-hide">{gt text='Reset to empty value'}</a></span>
            {/if}
            
                <span class="z-formnote">{gt text='Allowed file extensions:'} <span id="uploadFileFileExtensions">pdf</span></span>
            <span class="z-formnote">{gt text='Allowed file size:'} {'102400'|mufilesGetFileSize:'':false:false}</span>
            {if $mode ne 'create'}
                {if $file.uploadFile ne ''}
                    <span class="z-formnote">
                        {gt text='Current file'}:
                        <a href="{$file.uploadFileFullPathUrl}" title="{$formattedEntityTitle|replace:"\"":""}"{if $file.uploadFileMeta.isImage} rel="imageviewer[file]"{/if}>
                        {if $file.uploadFileMeta.isImage}
                            {thumb image=$file.uploadFileFullPath objectid="file-`$file.id`" preset=$fileThumbPresetUploadFile tag=true img_alt=$formattedEntityTitle}
                        {else}
                            {gt text='Download'} ({$file.uploadFileMeta.size|mufilesGetFileSize:$file.uploadFileFullPath:false:false})
                        {/if}
                        </a>
                    </span>
                {/if}
            {/if}
            {mufilesValidationError id='uploadFile' class='required'}
            {mufilesValidationError id='uploadFile' class='validate-upload'}
        </div>
    </fieldset>
    
    {include file='admin/collection/include_selectEditOne.tpl' group='file' alias='aliascollection' aliasReverse='alilasfile' mandatory=false idPrefix='mufilesFile_Aliascollection' linkingItem=$file displayMode='dropdown' allowEditing=true}
    {if $mode ne 'create'}
        {include file='admin/include_standardfields_edit.tpl' obj=$file}
    {/if}
    
    {* include display hooks *}
    {if $mode ne 'create'}
        {assign var='hookId' value=$file.id}
        {notifydisplayhooks eventname='mufiles.ui_hooks.files.form_edit' id=$hookId assign='hooks'}
    {else}
        {notifydisplayhooks eventname='mufiles.ui_hooks.files.form_edit' id=null assign='hooks'}
    {/if}
    {if is_array($hooks) && count($hooks)}
        {foreach key='providerArea' item='hook' from=$hooks}
            <fieldset>
                {$hook}
            </fieldset>
        {/foreach}
    {/if}
    
    {* include return control *}
    {if $mode eq 'create'}
        <fieldset>
            <legend>{gt text='Return control'}</legend>
            <div class="z-formrow">
                {formlabel for='repeatCreation' __text='Create another item after save'}
                    {formcheckbox group='file' id='repeatCreation' readOnly=false}
            </div>
        </fieldset>
    {/if}
    
    {* include possible submit actions *}
    <div class="z-buttons z-formbuttons">
    {foreach item='action' from=$actions}
        {assign var='actionIdCapital' value=$action.id|@ucwords}
        {gt text=$action.title assign='actionTitle'}
        {*gt text=$action.description assign='actionDescription'*}{* TODO: formbutton could support title attributes *}
        {if $action.id eq 'delete'}
            {gt text='Really delete this file?' assign='deleteConfirmMsg'}
            {formbutton id="btn`$actionIdCapital`" commandName=$action.id text=$actionTitle class=$action.buttonClass confirmMessage=$deleteConfirmMsg}
        {else}
            {formbutton id="btn`$actionIdCapital`" commandName=$action.id text=$actionTitle class=$action.buttonClass}
        {/if}
    {/foreach}
        {formbutton id='btnCancel' commandName='cancel' __text='Cancel' class='z-bt-cancel'}
    </div>
    {/mufilesFormFrame}
{/form}
</div>
{include file='admin/footer.tpl'}

{icon type='edit' size='extrasmall' assign='editImageArray'}
{icon type='delete' size='extrasmall' assign='removeImageArray'}


<script type="text/javascript">
/* <![CDATA[ */

    var formButtons, formValidator;

    function handleFormButton (event) {
        var result = formValidator.validate();
        if (!result) {
            // validation error, abort form submit
            Event.stop(event);
        } else {
            // hide form buttons to prevent double submits by accident
            formButtons.each(function (btn) {
                btn.addClassName('z-hide');
            });
        }

        return result;
    }

    document.observe('dom:loaded', function() {

        mufilesAddCommonValidationRules('file', '{{if $mode ne 'create'}}{{$file.id}}{{/if}}');
        {{* observe validation on button events instead of form submit to exclude the cancel command *}}
        formValidator = new Validation('{{$__formid}}', {onSubmit: false, immediate: true, focusOnError: false});
        {{if $mode ne 'create'}}
            var result = formValidator.validate();
        {{/if}}

        formButtons = $('{{$__formid}}').select('div.z-formbuttons input');

        formButtons.each(function (elem) {
            if (elem.id != 'btnCancel') {
                elem.observe('click', handleFormButton);
            }
        });

        Zikula.UI.Tooltips($$('.mufiles-form-tooltips'));
        mufilesInitUploadField('uploadFile');
    });

/* ]]> */
</script>
