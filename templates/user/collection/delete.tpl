{* purpose of this template: collections delete confirmation view in user area *}
{include file='user/header.tpl'}
<div class="mufiles-collection mufiles-delete">
    {gt text='Delete collection' assign='templateTitle'}
    {pagesetvar name='title' value=$templateTitle}
    <h2>{$templateTitle}</h2>

    <p class="z-warningmsg">{gt text='Do you really want to delete this collection ?'}</p>

    <form class="z-form" action="{modurl modname='MUFiles' type='user' func='delete' ot='collection' id=$collection.id}" method="post">
        <div>
            <input type="hidden" name="csrftoken" value="{insert name='csrftoken'}" />
            <input type="hidden" id="confirmation" name="confirmation" value="1" />
            <fieldset>
                <legend>{gt text='Confirmation prompt'}</legend>
                <div class="z-buttons z-formbuttons">
                    {gt text='Delete' assign='deleteTitle'}
                    {button src='14_layer_deletelayer.png' set='icons/small' text=$deleteTitle title=$deleteTitle class='z-btred'}
                    <a href="{modurl modname='MUFiles' type='user' func='view' ot='collection'}">{icon type='cancel' size='small' __alt='Cancel' __title='Cancel'} {gt text='Cancel'}</a>
                </div>
            </fieldset>

            {notifydisplayhooks eventname='mufiles.ui_hooks.collections.form_delete' id="`$collection.id`" assign='hooks'}
            {foreach key='providerArea' item='hook' from=$hooks}
            <fieldset>
                <legend>{$hookName}</legend>
                {$hook}
            </fieldset>
            {/foreach}
        </div>
    </form>
</div>
{include file='user/footer.tpl'}
