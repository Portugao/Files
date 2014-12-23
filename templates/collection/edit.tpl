{* purpose of this template: build the Form to edit an instance of collection *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
{pageaddvar name='javascript' value='modules/MUFiles/javascript/MUFiles_editFunctions.js'}
{pageaddvar name='javascript' value='modules/MUFiles/javascript/MUFiles_validation.js'}

{if $mode eq 'edit'}
    {gt text='Edit collection' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='edit'}
    {/if}
{elseif $mode eq 'create'}
    {gt text='Create collection' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='new'}
    {/if}
{else}
    {gt text='Edit collection' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='edit'}
    {/if}
{/if}
<div class="mufiles-collection mufiles-edit">
    {pagesetvar name='title' value=$templateTitle}
    {if $lct eq 'admin'}
        <div class="z-admin-content-pagetitle">
            {icon type=$adminPageIcon size='small' alt=$templateTitle}
            <h3>{$templateTitle}</h3>
        </div>
    {else}
        <h2>{$templateTitle}</h2>
    {/if}
{form cssClass='z-form'}
    {* add validation summary and a <div> element for styling the form *}
    {mufilesFormFrame}
    {formsetinitialfocus inputId='name'}

    <div id="mUFilesPanel" class="z-panels">
        <h3 id="z-panel-header-fields" class="z-panel-header z-panel-indicator z-pointer">{gt text='Fields'}</h3>
        <div class="z-panel-content z-panel-active" style="overflow: visible">
            <fieldset>
                <legend>{gt text='Content'}</legend>
                
                <div class="z-formrow">
                    {formlabel for='name' __text='Name' mandatorysym='1' cssClass=''}
                    {formtextinput group='collection' id='name' mandatory=true readOnly=false __title='Enter the name of the collection' textMode='singleline' maxLength=255 cssClass='required' }
                    {mufilesValidationError id='name' class='required'}
                </div>
                
                <div class="z-formrow">
                    {formlabel for='description' __text='Description' cssClass=''}
                    {formtextinput group='collection' id='description' mandatory=false __title='Enter the description of the collection' textMode='multiline' rows='6' cols='50' cssClass='' }
                </div>
                
                {if $lct eq 'admin'}
                <div class="z-formrow">
                    {formlabel for='inFrontend' __text='In frontend' cssClass=''}
                    {formcheckbox group='collection' id='inFrontend' readOnly=false __title='in frontend ?' cssClass='' }
                </div>
                {else}
                <div class="z-formrow" style="display: none;">
                    {formlabel for='inFrontend' __text='In frontend' cssClass=''}
                    {formcheckbox group='collection' id='inFrontend' readOnly=false __title='in frontend ?' cssClass='' }
                </div>
                {/if}
            </fieldset>
        </div>
        
        {include file='helper/include_categories_edit.tpl' obj=$collection groupName='collectionObj' panel=true}
        {include file='collection/include_selectOne.tpl' group='collection' alias='parent' aliasReverse='children' mandatory=false idPrefix='mufilesCollection_Parent' linkingItem=$collection panel=true displayMode='dropdown' allowEditing=false}
       {* {include file='hookobject/include_selectMany.tpl' group='collection' alias='hookcollection' aliasReverse='collectionhook' mandatory=false idPrefix='mufilesCollection_Hookcollection' linkingItem=$collection panel=true displayMode='dropdown' allowEditing=false} *}
        {if $mode ne 'create'}
            {include file='helper/include_standardfields_edit.tpl' obj=$collection panel=true}
        {/if}
        
        {* include display hooks *}
        {if $mode ne 'create'}
            {assign var='hookId' value=$collection.id}
            {notifydisplayhooks eventname='mufiles.ui_hooks.collections.form_edit' id=$hookId assign='hooks'}
        {else}
            {notifydisplayhooks eventname='mufiles.ui_hooks.collections.form_edit' id=null assign='hooks'}
        {/if}
        {if is_array($hooks) && count($hooks)}
            {foreach name='hookLoop' key='providerArea' item='hook' from=$hooks}
                <h3 class="hook z-panel-header z-panel-indicator z-pointer">{$providerArea}</h3>
                <fieldset class="hook z-panel-content" style="display: none">
                    {$hook}
                </fieldset>
            {/foreach}
        {/if}
        
        <fieldset>
            <legend>{gt text='Communication'}</legend>
            <div class="z-formrow">
                {usergetvar name='uid' assign='uid'}
                {formlabel for='additionalNotificationRemarks' __text='Additional remarks'}
                {gt text='Enter any additions about your changes' assign='fieldTitle'}
                {if $mode eq 'create'}
                    {gt text='Enter any additions about your content' assign='fieldTitle'}
                {/if}
                {formtextinput group='collection' id='additionalNotificationRemarks' mandatory=false title=$fieldTitle textMode='multiline' rows='6' cols='50'}
                {if $isModerator || $isSuperModerator}
                    <span class="z-formnote">{gt text='These remarks (like a reason for deny) are not stored, but added to any notification emails send to the creator.'}</span>
                {elseif $isCreator}
                    <span class="z-formnote">{gt text='These remarks (like questions about conformance) are not stored, but added to any notification emails send to our moderators.'}</span>
                {/if}
            </div>
        </fieldset>
        
        {* include return control *}
        {if $mode eq 'create'}
            <fieldset>
                <legend>{gt text='Return control'}</legend>
                <div class="z-formrow">
                    {formlabel for='repeatCreation' __text='Create another item after save'}
                        {formcheckbox group='collection' id='repeatCreation' readOnly=false}
                </div>
            </fieldset>
        {/if}
        
        {* include possible submit actions *}
        <div class="z-buttons z-formbuttons">
        {foreach item='action' from=$actions}
            {assign var='actionIdCapital' value=$action.id|@ucfirst}
            {gt text=$action.title assign='actionTitle'}
            {*gt text=$action.description assign='actionDescription'*}{* TODO: formbutton could support title attributes *}
            {if $action.id eq 'delete'}
                {gt text='Really delete this collection?' assign='deleteConfirmMsg'}
                {formbutton id="btn`$actionIdCapital`" commandName=$action.id text=$actionTitle class=$action.buttonClass confirmMessage=$deleteConfirmMsg}
            {else}
                {formbutton id="btn`$actionIdCapital`" commandName=$action.id text=$actionTitle class=$action.buttonClass}
            {/if}
        {/foreach}
        {formbutton id='btnCancel' commandName='cancel' __text='Cancel' class='z-bt-cancel'}
        </div>
    </div>
    {/mufilesFormFrame}
{/form}
</div>
{include file="`$lct`/footer.tpl"}

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
    
        mUMUFilesAddCommonValidationRules('collection', '{{if $mode ne 'create'}}{{$collection.id}}{{/if}}');
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
    
        var panel = new Zikula.UI.Panels('mUFilesPanel', {
            headerSelector: 'h3',
            headerClassName: 'z-panel-header z-panel-indicator',
            contentClassName: 'z-panel-content',
            active: $('z-panel-header-fields')
        });
    
        Zikula.UI.Tooltips($$('.mufiles-form-tooltips'));
    });
/* ]]> */
</script>
