{include file='header.tpl'}

<div class="container">
    {if isset($product_id)}
        {* A single product's own detail page (products-display.tpl), as
           opposed to a product *listing* (products-list.tpl) reusing this
           same layout - sidebar.tpl has nothing to show here (its filter
           block only ever renders for a listing's $product_filter, and the
           category/TOC/snippet blocks are typically empty for a single
           item too), so skip the column entirely instead of leaving an
           empty one and let the product use the full width. Same
           isset($product_id) check content.tpl already uses to tell a
           listing and a single item apart. *}
        {include file='content.tpl'}
    {else}
        <div class="row">
            <div class="col-lg-9">
                {include file='content.tpl'}
            </div>
            <div class="col">
                <!-- sidebar -->
                {include file='sidebar.tpl'}

            </div>
        </div>
    {/if}
</div>

{include file='footer.tpl'}
