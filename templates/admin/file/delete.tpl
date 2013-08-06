{* purpose of this template: files delete confirmation view in admin area *}
{include file='admin/header.tpl'}
<div class="mufiles-file mufiles-delete">
{gt text='Delete file' assign='templateTitle'}
{pagesetvar name='title' value=$templateTitle}
<div class="z-admin-content-pagetitle">
    {icon type='delete' size='small' __alt='Delete'}
    <h3>{$templateTitle}</h3>
</div>

<p class="z-warningmsg">{gt text='Do you really want to delete this file ?'}</p>

<form class="z-form" action="{modurl modname='MUFiles' type='admin' func='delete' ot='file' id=$file.id}" method="post">
    <div>
        <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
        <input type="hidden" id="confirmation" name="confirmation" value="1" />
        <fieldset>
            <legend>{gt text='Confirmation prompt'}</legend>
            <div class="z-buttons z-formbuttons">
                {gt text='Delete' assign='deleteTitle'}
                {button src='14_layer_deletelayer.png' set='icons/small' text=$deleteTitle title=$deleteTitle class='z-btred'}
                <a href="{modurl modname='MUFiles' type='admin' func='view' ot='file'}">{icon type='cancel' size='small' __alt='Cancel' __title='Cancel'} {gt text='Cancel'}</a>
            </div>
        </fieldset>

        {notifydisplayhooks eventname='mufiles.ui_hooks.files.form_delete' id="`$file.id`" assign='hooks'}
        {foreach key='providerArea' item='hook' from=$hooks}
        <fieldset>
            <legend>{$hookName}</legend>
            {$hook}
        </fieldset>
        {/foreach}
    </div>
</form>
</div>
{include file='admin/footer.tpl'}
