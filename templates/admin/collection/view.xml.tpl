{* purpose of this template: collections view xml view in admin area *}
{mufilesTemplateHeaders contentType='text/xml'}<?xml version="1.0" encoding="{charset}" ?>
<collections>
{foreach item='item' from=$items}
    {include file='admin/collection/include.xml'}
{foreachelse}
    <noCollection />
{/foreach}
</collections>
