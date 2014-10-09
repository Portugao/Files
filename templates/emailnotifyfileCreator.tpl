<p>{gt text='Hello %s' tag=$recipient.name},</p>

<p>{gt text='Your file "%s" has been changed.' tag=$mailData.name}</p>

<p>{gt text='It\'s new state is: %s' tag=$mailData.newState}</p>

{if $mailData.remarks ne ''}
    <p>{gt text='Additional remarks:'} {$mailData.remarks|safetext}</p>
{/if}


<p>{gt text='Link to the file:'} <a href="{$mailData.displayUrl|safetext}" title="{$mailData.name|replace:'"':''}">{$mailData.displayUrl|safetext}</a></p>
<p>{gt text='Edit your file:'} <a href="{$mailData.editUrl|safetext}" title="{gt text='Edit'}">{$mailData.editUrl|safetext}</a></p>

<p>{gt text='This mail has been sent automatically by %s.' tag=$modvars.ZConfig.sitename}</p>
