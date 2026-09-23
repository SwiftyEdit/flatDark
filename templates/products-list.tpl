<div id="article_list_header">

    <div class="d-flex justify-content-between align-items-center mb-1">
        <div>
            <div class="btn-group" role="group" title="{$lang_sort}">
                <a href="{$sort_urls.default}"
                   class="btn btn-sm btn-outline-secondary {if !$class_sort_name && !$class_sort_topseller && !$class_sort_price_asc && !$class_sort_price_desc}active{/if}">
                    {$lang_label_sort_relevance}
                </a>
                <a href="{$sort_urls.name}"
                   class="btn btn-sm btn-outline-secondary {$class_sort_name}">
                    A-Z
                </a>
                <a href="{$sort_urls.pasc}"
                   class="btn btn-sm btn-outline-secondary {$class_sort_price_asc}">
                    {$lang_label_price} ↑
                </a>
                <a href="{$sort_urls.pdesc}"
                   class="btn btn-sm btn-outline-secondary {$class_sort_price_desc}">
                    {$lang_label_price} ↓
                </a>
                <a href="{$sort_urls.ts}"
                   class="btn btn-sm btn-outline-secondary {$class_sort_topseller}">
                    {$lang_label_sort_topseller}
                </a>
            </div>
        </div>
        <div>
            {$nbr_products} {$lang_label_products}
        </div>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-1">
        {if $has_active_filters}
            <div class="active-filters-bar">
                <div class="filter-tags">
                    {foreach $active_filter_tags as $tag}
                        <a href="{$tag.remove_url}" class="btn btn-sm btn-outline-secondary">
                            <span class="filter-remove"><i class="bi bi-x-circle"></i></span>
                            <span class="filter-label small">{$tag.filter_title}:</span>
                            <span class="filter-value">{$tag.display}</span>
                        </a>
                    {/foreach}

                    {* "Alle zurücksetzen" Link *}
                    <a href="{$page_slug}" class="clear-all-filters btn btn-sm btn-outline-secondary">
                        {$lang_reset}
                    </a>
                </div>
            </div>
        {/if}
        {if $show_pagination}
            <div class="flex-fill">
            <nav aria-label="Pagination" class="mt-4">
                <ul class="pagination pagination-sm justify-content-end">
                    <li class="page-item {if $disable_prev_link}disabled{/if}">
                        <a class="page-link" href="{$filter_base_url}{$pag_prev_href}">«</a>
                    </li>

                    {foreach $pagination as $page}
                        <li class="page-item {$page.active_class}">
                            <a class="page-link" href="{$filter_base_url}{$page.href}">{$page.nbr}</a>
                        </li>
                    {/foreach}

                    <li class="page-item {if $disable_next_link}disabled{/if}">
                        <a class="page-link" href="{$filter_base_url}{$pag_next_href}">»</a>
                    </li>
                </ul>
            </nav>
            </div>
        {/if}
    </div>
</div>

{if $show_products_list == true}

<div class="row row-cols-1 row-cols-sm-2 g-4 product-grid">
{foreach $products as $product => $value}

    <div class="col">
    <div class="product-list-entry {$value.product_css_classes}">
        {$value.draft_message}

        <!-- pricetag: captured once, then placed either over the image
             (the normal case) or in the body below if there's no image to
             overlay it on -->
        {if $value.product_pricetag_mode !== 2}
            {capture name="pricetag"}
                <div class="price-tag price-tag-fix">
                    {if $value.product_price_label != ''}
                        <div class="clearfix">
                            <div class="price-tag-label">{$value.product_price_label}</div>
                        </div>
                    {/if}
                    <div class="price-tag-inner">
                        <div class="price">
                            {if $value.price_tag_label_from != ''}{$value.price_tag_label_from}{/if}
                            {$value.price_tag}</div>
                        {$value.product_currency} <span class="product-amount">{$value.product_amount}</span> <span class="product-unit">{$value.product_unit}</span>
                    </div>
                </div>
            {/capture}
        {/if}

        {if $value.product_img_src != ''}
            <div class="teaser-image-wrap">
                <a href="{$value.product_href}" class="teaser-image" tabindex="-1" aria-hidden="true">
                    {img src="{$value.product_img_src}" widths="400,800,1200" sizes="(max-width: 575px) 100vw, (max-width: 991px) 50vw, 350px" alt="{$value.product_title|escape}" class="img-fluid"}
                </a>
                {$smarty.capture.pricetag}
            </div>
        {/if}

        <div class="product-list-entry-body">

            {if $value.product_img_src == ''}
                {$smarty.capture.pricetag}
            {/if}

            <span class="post-author">{$value.product_author}</span> <span class="post-releasedate">{$pvalue.product_releasedate}</span>
            <a class="post-headline-link" href="{$value.product_href}"><h3>{$value.product_title}</h3></a>
            {$value.product_teaser}

            <div class="product-list-entry-actions">
                {if $value.show_voting == true}
                    {$hidden_csrf_token}
                    <div class="mb-1">
                        <button class="btn btn-sm btn-outline-secondary" hx-post="/xhr/se/vote/" hx-swap="none" hx-include="[name='csrf_token']" name="vote" value="up-product-{$value.product_id}" {$value.votes_status_up}>
                            <i class="bi bi-hand-thumbs-up-fill"></i> <span hx-get="/xhr/se/votes/?section=s&upv={$value.product_id}" hx-swap="innerHTML" hx-trigger="load, update_votings_{$value.product_id} from:body">0</span>
                        </button>
                        <button class="btn btn-sm btn-outline-secondary" hx-post="/xhr/se/vote/" hx-swap="none" hx-include="[name='csrf_token']" name="vote" value="dn-product-{$value.product_id}" {$value.votes_status_dn}>
                            <i class="bi bi-hand-thumbs-down-fill"></i> <span hx-get="/xhr/se/votes/?section=s&dnv={$value.product_id}" hx-swap="innerHTML" hx-trigger="load, update_votings_{$value.product_id} from:body">0</span>
                        </button>
                    </div>
                {/if}

                {if $value.variants_alert != ''}
                    {$value.variants_alert}
                {/if}

                {* No "add to cart" here on the catalog/listing page - that
                   action lives on the product's own detail page now; this
                   is just the entry point to it, so it gets the emphasis
                   instead (outline-primary instead of a plain link).
                   Wishlist sits on the same row, icon-only - its label
                   still needs to exist somewhere for accessibility/clarity,
                   so it moves to title/aria-label instead of visible text. *}
                <div class="d-flex align-items-center gap-2">
                    <a class="btn btn-outline-primary flex-grow-1 {$link_classes}" href="{$value.product_href}">{$btn_read_more}</a>
                    {if $value.show_wishlist_button == true}
                        {if $smarty.session.user_nick != ''}
                            <button type="button" class="btn btn-link flex-shrink-0"
                                    title="{$lang_btn_add_to_wishlist}" aria-label="{$lang_btn_add_to_wishlist}"
                                    hx-get="/xhr/se/wishlist/?form=picker&product_id={$value.product_id}&product_href={$value.product_href|escape:'url'}"
                                    hx-target="#wishlist-picker-modal-body"
                                    hx-swap="innerHTML"
                                    data-bs-toggle="modal" data-bs-target="#wishlist-picker-modal">
                                <i class="bi bi-heart"></i>
                            </button>
                        {else}
                            <a class="btn btn-link flex-shrink-0" href="{$wishlist_login_uri}" title="{$lang_btn_add_to_wishlist}" aria-label="{$lang_btn_add_to_wishlist}">
                                <i class="bi bi-heart"></i>
                            </a>
                        {/if}
                    {/if}
                </div>
            </div>

            {* Categories dropped here on purpose - the category sidebar
               (sidebar-categories.tpl) already shows them; repeating them
               per card was redundant. *}
            <div class="m-0 content-tags text-end">
                {foreach $value.content_tags as $tag}
                    <a href="{$tag.tag_href}" class="btn btn-sm btn-link" title="{$tag.tag_title}">#{$tag.tag_title}</a>
                {/foreach}
            </div>
        </div>
    </div>
    </div>

 {/foreach}
</div>

{else}
    <div class="alert alert-info">
        {$lang_msg_no_products_found}
    </div>
{/if}

<div class="product-list-footer">
    {if $show_pagination}
        <nav aria-label="Pagination" class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item {if $disable_prev_link}disabled{/if}">
                    <a class="page-link" href="{$filter_base_url}{$pag_prev_href}">«</a>
                </li>

                {foreach $pagination as $page}
                    <li class="page-item {$page.active_class}">
                        <a class="page-link" href="{$filter_base_url}{$page.href}">{$page.nbr}</a>
                    </li>
                {/foreach}

                <li class="page-item {if $disable_next_link}disabled{/if}">
                    <a class="page-link" href="{$filter_base_url}{$pag_next_href}">»</a>
                </li>
            </ul>
        </nav>
    {/if}
</div>

{if $prefs_wishlist_enabled == 1}
<div class="modal fade" id="wishlist-picker-modal" tabindex="-1" aria-labelledby="wishlistPickerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="wishlistPickerModalLabel">{$lang_legend_add_to_wishlist}</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="wishlist-picker-modal-body">
            </div>
        </div>
    </div>
</div>
{/if}
