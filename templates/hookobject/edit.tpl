{* purpose of this template: build the Form to edit an instance of hookobject *}
{assign var='lct' value='user'}
{if isset($smarty.get.lct) && $smarty.get.lct eq 'admin'}
    {assign var='lct' value='admin'}
{/if}
{include file="`$lct`/header.tpl"}
{pageaddvar name='javascript' value='modules/MUFiles/javascript/MUFiles_editFunctions.js'}
{pageaddvar name='javascript' value='modules/MUFiles/javascript/MUFiles_validation.js'}

{if $mode eq 'edit'}
    {gt text='Edit hookobject' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='edit'}
    {/if}
{elseif $mode eq 'create'}
    {gt text='Create hookobject' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='new'}
    {/if}
{else}
    {gt text='Edit hookobject' assign='templateTitle'}
    {if $lct eq 'admin'}
        {assign var='adminPageIcon' value='edit'}
    {/if}
{/if}
<div class="mufiles-hookobject mufiles-edit">
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
    {formsetinitialfocus inputId='hookedModule'}

    <fieldset>
        <legend>{gt text='Content'}</legend>
        
        <div class="z-formrow">
            {formlabel for='hookedModule' __text='Hooked module' mandatorysym='1' cssClass=''}
            {formtextinput group='hookobject' id='hookedModule' mandatory=true readOnly=false __title='Enter the hooked module of the hookobject' textMode='singleline' maxLength=50 cssClass='required' }
            {mufilesValidationError id='hookedModule' class='required'}
        </div>
        
        <div class="z-formrow">
            {formlabel for='areaId' __text='Area id' mandatorysym='1' cssClass=''}
            {formintinput group='hookobject' id='areaId' mandatory=true __title='Enter the area id of the hookobject' maxLength=11 cssClass='required validate-digits' }
            {mufilesValidationError id='areaId' class='required'}
            {mufilesValidationError id='areaId' class='validate-digits'}
        </div>
        
        <div class="z-formrow">
            {formlabel for='url' __text='Url' mandatorysym='1' cssClass=''}
            {formtextinput group='hookobject' id='url' mandatory=true readOnly=false __title='Enter the url of the hookobject' textMode='singleline' maxLength=255 cssClass='required' }
            {mufilesValidationError id='url' class='required'}
        </div>
        
        <div class="z-formrow">
            {formlabel for='objectId' __text='Object id' mandatorysym='1' cssClass=''}
            {formintinput group='hookobject' id='objectId' mandatory=true __title='Enter the object id of the hookobject' maxLength=11 cssClass='required validate-digits' }
            {mufilesValidationError id='objectId' class='required'}
            {mufilesValidationError id='objectId' class='validate-digits'}
        </div>
    </fieldset>
    
    {include file='collection/include_selectEditMany.tpl' group='hookobject' alias='collectionhook' aliasReverse='hookcollection' mandatory=false idPrefix='mufilesHookobject_Collectionhook' linkingItem=$hookobject displayMode='dropdown' allowEditing=true}
    {include file='file/include_selectEditMany.tpl' group='hookobject' alias='filehook' aliasReverse='hookfile' mandatory=false idPrefix='mufilesHookobject_Filehook' linkingItem=$hookobject displayMode='dropdown' allowEditing=true}
    {if $mode ne 'create'}
        {include file='helper/include_standardfields_edit.tpl' obj=$hookobject}
    {/if}
    
    {* include display hooks *}
    {if $mode ne 'create'}
        {assign var='hookId' value=$hookobject.id}
        {notifydisplayhooks eventname='mufiles.ui_hooks.hookobjects.form_edit' id=$hookId assign='hooks'}
    {else}
        {notifydisplayhooks eventname='mufiles.ui_hooks.hookobjects.form_edit' id=null assign='hooks'}
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
                    {formcheckbox group='hookobject' id='repeatCreation' readOnly=false}
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
            {gt text='Really delete this hookobject?' assign='deleteConfirmMsg'}
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

        mufilesAddCommonValidationRules('hookobject', '{{if $mode ne 'create'}}{{$hookobject.id}}{{/if}}');
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
    });

/* ]]> */
</script>
