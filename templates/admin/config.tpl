{* purpose of this template: module configuration *}
{include file='admin/header.tpl'}
<div class="mufiles-config">
    {gt text='Settings' assign='templateTitle'}
    {pagesetvar name='title' value=$templateTitle}
    <div class="z-admin-content-pagetitle">
        {icon type='config' size='small' __alt='Settings'}
        <h3>{$templateTitle}</h3>
    </div>

    {form cssClass='z-form'}
        {* add validation summary and a <div> element for styling the form *}
        {mufilesFormFrame}
            {formsetinitialfocus inputId='allowedExtensions'}
            {formtabbedpanelset}
                {gt text='General' assign='tabTitle'}
                {formtabbedpanel title=$tabTitle}
                    <fieldset>
                        <legend>{$tabTitle}</legend>
                    
                        <p class="z-confirmationmsg">{gt text='Here you can manage all basic settings for this application.'}</p>
                    
                        <div class="z-formrow">
                            {gt text='A list of the allowed extensions; comma seperated.' assign='toolTip'}
                            {formlabel for='allowedExtensions' __text='Allowed extensions' cssClass='mufiles-form-tooltips ' title=$toolTip}
                                {formtextinput id='allowedExtensions' group='config' maxLength=255 __title='Enter the allowed extensions.'}
                        </div>
                        <div class="z-formrow">
                            {formlabel for='maxSize' __text='Max size' cssClass=''}
                                {formintinput id='maxSize' group='config' maxLength=255 __title='Enter the max size. Only digits are allowed.'}
                        </div>
                    </fieldset>
                {/formtabbedpanel}
                {gt text='Moderation' assign='tabTitle'}
                {formtabbedpanel title=$tabTitle}
                    <fieldset>
                        <legend>{$tabTitle}</legend>
                    
                        <p class="z-confirmationmsg">{gt text='Here you can assign moderation groups for enhanced workflow actions.'|nl2br}</p>
                    
                        <div class="z-formrow">
                            {gt text='Used to determine moderator user accounts for sending email notifications.' assign='toolTip'}
                            {formlabel for='moderationGroupForCollections' __text='Moderation group for collections' cssClass='mufiles-form-tooltips ' title=$toolTip}
                                {formdropdownlist id='moderationGroupForCollections' group='config' __title='Choose the moderation group for collections'}
                        </div>
                        <div class="z-formrow">
                            {gt text='Used to determine moderator user accounts for sending email notifications.' assign='toolTip'}
                            {formlabel for='moderationGroupForFiles' __text='Moderation group for files' cssClass='mufiles-form-tooltips ' title=$toolTip}
                                {formdropdownlist id='moderationGroupForFiles' group='config' __title='Choose the moderation group for files'}
                        </div>
                    </fieldset>
                {/formtabbedpanel}
            {/formtabbedpanelset}

            <div class="z-buttons z-formbuttons">
                {formbutton commandName='save' __text='Update configuration' class='z-bt-save'}
                {formbutton commandName='cancel' __text='Cancel' class='z-bt-cancel'}
            </div>
        {/mufilesFormFrame}
    {/form}
</div>
{include file='admin/footer.tpl'}
<script type="text/javascript">
/* <![CDATA[ */
    document.observe('dom:loaded', function() {
        Zikula.UI.Tooltips($$('.mufiles-form-tooltips'));
    });
/* ]]> */
</script>
