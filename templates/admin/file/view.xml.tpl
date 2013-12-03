{* purpose of this template: files view xml view in admin area *}
{mufilesTemplateHeaders contentType='text/xml'}<?xml version="1.0" encoding="{charset}" ?>
<files>
{foreach item='item' from=$items}
    {include file='admin/file/include.xml'}
{foreachelse}
    <noFile />
{/foreach}
</files>
