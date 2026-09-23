<div class="post-product">

    {if isset($smarty.session.last_shop_url)}
        <a href="{$smarty.session.last_shop_url}" class="btn btn-sm btn-outline-secondary mb-2">
            <i class="bi bi-arrow-left-short"></i> {$lang_button_back}
        </a>
    {/if}

    {* Three regions, reordered per breakpoint instead of by DOM position:
       image / buy box (price + cart) / title+teaser. Mobile has no order-md-*
       utilities in play, so it just follows DOM order - image, then the buy
       box right after it, then the title - exactly the "buy box right after
       the image on mobile" requirement. At md+ the buy box moves to order 3
       (the right column) and the title to order 2 (the middle), with the
       image (no explicit order, so the default order:0) staying left. *}
    <div class="row product-display-row g-4">

        {if $product_img_src != ''}
        <div class="col-md-3">
            {img src="{$product_img_src}" widths="400,800,1200" sizes="(max-width: 767px) 100vw, (max-width: 991px) 170px, (max-width: 1199px) 230px, (max-width: 1399px) 280px, 320px" alt="{$product_img_alt}" title="{$product_img_title}" class="img-fluid"}<br>
            <small>{$product_img_caption}</small>

            {if is_array($product_show_images)}
            <section data-featherlight-gallery data-featherlight-filter="a">
            <div class="row mt-3 g-1">

                {foreach $product_show_images as $img => $value}
                <div class="col-3">
                    <a href="{$value.media_file}" title="{$value.media_title}" class="lightbox">
                        <img src="{$value.media_file}" alt="{$value.media_alt}" class="img-fluid">
                    </a>
                </div>
                {/foreach}

            </div>
            </section>
            {/if}
        </div>
        {/if}

        <div class="col-md-3 order-md-3">
            <div class="product-buy-box">

                {* wishlist button - shown next to "add to cart" when that button is
                   rendered, or on its own nearby the price when it isn't (e.g.
                   addon-only products, or cart/price hidden for this product) *}
                {capture name="wishlist_btn"}
                    {if $show_wishlist_button}
                        <div class="text-end">
                        {if $wishlist_logged_in}
                            <button type="button" class="btn btn-link btn-sm{if $wishlist_already_saved} active{/if}"
                                    hx-get="/xhr/se/wishlist/?form=picker&product_id={$product_id}&product_href={$product_href|escape:'url'}"
                                    hx-target="#wishlist-picker-modal-body"
                                    hx-swap="innerHTML"
                                    data-bs-toggle="modal" data-bs-target="#wishlist-picker-modal">
                                <i class="bi bi-heart"></i> {$lang_btn_add_to_wishlist}
                            </button>
                        {else}
                            <a class="btn btn-link btn-sm" href="{$wishlist_login_uri}">
                                <i class="bi bi-heart"></i> {$lang_btn_add_to_wishlist}
                            </a>
                        {/if}
                        </div>
                    {/if}
                {/capture}

                <!-- pricetag -->
                {if $product_pricetag_mode != "2"}
                    <div class="price-tag d-inline-block">
                        <div class="clearfix">
                            <div class="price-tag-label">{$product_price_label}</div>
                        </div>
                        <div class="price-tag-inner">
                            {$product_currency} <span id="price-display">{$product_price_tag}</span> <span class="product-amount">{$product_amount}</span> <span class="product-unit">{$product_unit}</span>
                        </div>
                        <div class="price-tag-note">{$product_tax_label}</div>
                    </div>

                    <div class="delivery-time">
                        {$label_delivery_time}: <span><strong>{$product_delivery_time_title}</strong> {$product_delivery_time_text}</span>
                    </div>
                    {if $product_cart_mode != "2"}
                    {if $is_addon_only}
                        <div class="alert alert-info mt-3">{$product_addon_only_note}</div>
                        <div class="mt-2">{$smarty.capture.wishlist_btn}</div>
                    {else}
                    <div class="mt-3">
                        <form action="{$form_action}" method="POST" class="text-start d-inline"
                              hx-post="/xhr/se/products/"
                              hx-target="#add-to-cart-message-{$product_id}"
                              hx-swap="innerHTML">

                            {if is_array($select_options)}
                                <!-- product options -->
                                {foreach $select_options as $option}
                                    <label class="form-label">{$option.title}</label>
                                    <select class="form-select w-auto" name="product_options[]">
                                        {foreach $option.values as $value}
                                            <option value="{$option.title}: {$value}">{$value}</option>
                                        {/foreach}
                                    </select>
                                {/foreach}

                            {/if}

                            {if is_array($select_addons)}
                                <!-- product addons (bookable options) -->
                                <div class="card my-2">
                                    {if $product_addons_label != ""}
                                    <h5 class="card-header">{$product_addons_label}</h5>
                                    {/if}
                                    <div class="list-group">
                                    {foreach $select_addons as $addon}
                                        <label class="list-group-item d-flex gap-3">
                                            <input class="form-check-input flex-shrink-0 fs-4" type="checkbox" name="product_addons[]" value="{$addon.id}" id="addon_{$addon.id}">
                                            <span class="pt-1 flex-grow-1 form-checked-content">
                                            <strong>{$addon.title}</strong>
                                            <span class="d-block text-muted">(+ {$product_currency} {$addon.price} <span class="product-amount">{$addon.amount}</span> <span class="product-unit">{$addon.unit}</span>)</span>
                                            </span>
                                            <span class="flex-shrink-0 mt-1 rounded" style="background-image: url('{$addon.image_src}');width:45px;height:45px;background-size: cover;background-position: center;background-repeat: no-repeat;">
                                           </span>
                                            <button type="button" class="flex-shrink-0 btn btn-link"
                                                    data-bs-html="true"
                                                    data-bs-container="body"
                                                    data-bs-toggle="popover"
                                                    data-bs-placement="top"
                                                    data-bs-trigger="hover focus"
                                                    data-bs-title="{$addon.title}"
                                                    data-bs-content="{$addon.teaser}">
                                                <i class="bi bi-info-circle"></i>
                                            </button>
                                        </label>
                                    {/foreach}
                                    </div>
                                </div>
                            {/if}

                            {if $product_options_comment_label != ""}
                                <label class="form-label">{$product_options_comment_label}</label>
                                <textarea class="form-control" name="customer_options_comment"></textarea>
                            {/if}
                        {if $file_upload_message != ''}
                            <div class="alert alert-info my-3">
                                {$file_upload_message}
                            </div>
                        {/if}
                            {* The buy box is a narrow column - the quantity
                               stepper, add-to-cart and wishlist buttons used
                               to sit side by side (sized for the old, much
                               wider column) and don't fit that way anymore,
                               so they stack full-width instead (d-grid). *}
                            <div class="mt-2 pt-2 border-top d-grid gap-2">
                                <div class="input-group">
                                <button type="button" class="btn btn-outline-secondary" onclick="adjustQuantity(-1)">−</button>
                                <input type="number"
                                       id="quantity"
                                       name="amount"
                                       value="{$product_amount}" {$product_order_quantity_min} {$product_order_quantity_max}
                                       class="form-control form-control-lg"
                                       hx-get="/xhr/se/products/?calc=price&product_id={$product_id}"
                                       hx-target="#price-display"
                                       hx-trigger="keyup changed delay:500ms, input"
                                >
                                <button type="button" class="btn btn-outline-secondary" onclick="adjustQuantity(1)">+</button>
                                </div>
                                <button class="btn btn-outline-primary btn-lg" name="add_to_cart" value="{$product_id}">{$btn_add_to_cart}</button>
                                {$smarty.capture.wishlist_btn}
                            </div>
                            <div id="add-to-cart-message-{$product_id}" class="mt-1"></div>
                            <input type="hidden" name="product_href" value="{$product_href}">
                            {$hidden_csrf_token}

                        </form>
                    </div>
                    {/if}
                    {else}
                        <div class="mt-3">{$smarty.capture.wishlist_btn}</div>
                    {/if}
                {else}
                    <div class="mt-3">{$smarty.capture.wishlist_btn}</div>
                {/if}
                <!-- pricetag end -->

            </div>
        </div>

        <div class="col-md-6 order-md-2">

            <h1>{$product_title}</h1>
            {$product_teaser}
            {if $content_tags == true}
                <p class="m-0 content-tags">
                    {foreach $content_tags as $tag}
                        <a href="{$tag.tag_href}" class="btn btn-sm btn-link" title="{$tag.tag_title}">#{$tag.tag_title}</a>
                    {/foreach}
                </p>
            {/if}
        </div>
    </div>

    {* Was a tab bar - a stack of independent collapses instead, mainly
       because a row of tabs either wraps awkwardly or needs horizontal
       scrolling once there are more than 2-3 of these (up to 8 possible
       here), while a stacked list just works the same way regardless of
       screen width. Deliberately *not* a real Bootstrap accordion - no
       data-bs-parent linking them - each item opens/closes on its own, so
       reading a longer section can't suddenly get yanked shut by opening a
       different one. The first item (the product's own text) starts open,
       matching the old tab bar's default active pane; the rest start
       collapsed. The .accordion class is still just Bootstrap's visual
       styling for a stacked collapse list - it's the data-bs-parent
       attribute that would make it behave as an accordion, and that's
       exactly what's left out here. *}
    <div class="accordion post-text mt-3" id="productInfoCollapses">

        {if $product_text_label != ""}
        <div class="accordion-item">
            <h2 class="accordion-header">
                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#pi-main" aria-expanded="true" aria-controls="pi-main">
                    {$product_text_label}
                </button>
            </h2>
            <div id="pi-main" class="accordion-collapse collapse show">
                <div class="accordion-body">
                    {$product_text}
                </div>
            </div>
        </div>
        {/if}

        {if is_array($product_features)}
        <div class="accordion-item">
            <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#pi-features" aria-expanded="false" aria-controls="pi-features">
                    {$label_product_features}
                </button>
            </h2>
            <div id="pi-features" class="accordion-collapse collapse">
                <div class="accordion-body">
                    <table class="table table-sm">
                        {foreach $product_features as $feature => $value}
                            <tr>
                                <td>{$value.snippet_title}</td>
                                <td>{$value.snippet_content}</td>
                            </tr>
                        {/foreach}
                    </table>
                </div>
            </div>
        </div>
        {/if}

        {if is_array($show_volume_discounts)}
        <div class="accordion-item">
            <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#pi-volume-discounts" aria-expanded="false" aria-controls="pi-volume-discounts">
                    {$label_prices_discount}
                </button>
            </h2>
            <div id="pi-volume-discounts" class="accordion-collapse collapse">
                <div class="accordion-body">
                    <table class="table table-sm">
                        <tr>
                            <td>Menge</td>
                            <td>Netto</td>
                            <td>Brutto</td>
                        </tr>
                        {foreach $show_volume_discounts as $discount => $value}
                            <tr>
                                <td># {$value.amount}</td>
                                <td>{$value.price_net}</td>
                                <td>{$value.price_gross}</td>
                            </tr>
                        {/foreach}
                    </table>
                </div>
            </div>
        </div>
        {/if}

        {if $text_additional1_label != ""}
        <div class="accordion-item">
            <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#pi-additional1" aria-expanded="false" aria-controls="pi-additional1">
                    {$text_additional1_label}
                </button>
            </h2>
            <div id="pi-additional1" class="accordion-collapse collapse">
                <div class="accordion-body">
                    {$text_additional1}
                </div>
            </div>
        </div>
        {/if}

        {if $text_additional2_label != ""}
        <div class="accordion-item">
            <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#pi-additional2" aria-expanded="false" aria-controls="pi-additional2">
                    {$text_additional2_label}
                </button>
            </h2>
            <div id="pi-additional2" class="accordion-collapse collapse">
                <div class="accordion-body">
                    {$text_additional2}
                </div>
            </div>
        </div>
        {/if}

        {if $text_additional3_label != ""}
        <div class="accordion-item">
            <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#pi-additional3" aria-expanded="false" aria-controls="pi-additional3">
                    {$text_additional3_label}
                </button>
            </h2>
            <div id="pi-additional3" class="accordion-collapse collapse">
                <div class="accordion-body">
                    {$text_additional3}
                </div>
            </div>
        </div>
        {/if}

        {if $text_additional4_label != ""}
        <div class="accordion-item">
            <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#pi-additional4" aria-expanded="false" aria-controls="pi-additional4">
                    {$text_additional4_label}
                </button>
            </h2>
            <div id="pi-additional4" class="accordion-collapse collapse">
                <div class="accordion-body">
                    {$text_additional4}
                </div>
            </div>
        </div>
        {/if}

        {if $text_additional5_label != ""}
        <div class="accordion-item">
            <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#pi-additional5" aria-expanded="false" aria-controls="pi-additional5">
                    {$text_additional5_label}
                </button>
            </h2>
            <div id="pi-additional5" class="accordion-collapse collapse">
                <div class="accordion-body">
                    {$text_additional5}
                </div>
            </div>
        </div>
        {/if}

        {if $text_scope_of_delivery != ""}
        <div class="accordion-item">
            <h2 class="accordion-header">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#pi-sod" aria-expanded="false" aria-controls="pi-sod">
                    {$lang_label_scope_of_delivery}
                </button>
            </h2>
            <div id="pi-sod" class="accordion-collapse collapse">
                <div class="accordion-body">
                    {$text_scope_of_delivery}
                </div>
            </div>
        </div>
        {/if}

    </div>


    {if is_array($show_variants)}
        <div class="card mb-3 variants-picker">
            <div class="card-header d-flex justify-content-between">
                <div>{$lang_label_product_variants}</div>
                {if $product_lowest_price_gross}
                <div>{$lang_price_tag_label_from} {$product_currency} {$product_lowest_price_gross}</div>
                {/if}
            </div>
            <div class="card-body">
                {* A fixed 4-column grid used to grow to as many rows as
                   needed - fine for a handful of items, unreadable (and
                   very tall) with a long list. A horizontally scrolling
                   strip instead keeps this section a fixed height no
                   matter how many there are - see .related-scroller in
                   _shop.scss. *}
                <div class="related-scroller">
                    {foreach $show_variants as $product => $value}
                        <div class="card {$value.class}">
                            {if $value.image != ""}
                            <img src="{$value.image}" class="card-img-top" alt="{$value.title}"
                                 title="{$value.title}">
                            {/if}
                            <div class="card-body fs-6 lh-sm">
                                <h6 class="card-title mb-0">{$value.title}</h6>
                                <small>{$value.teaser}</small>
                                {if $value.class != 'active'}
                                    <a href="{$value.product_href}" class="stretched-link" title="{$value.title}"> </a>
                                {/if}
                            </div>
                        </div>
                    {/foreach}
                </div>
            </div>
        </div>
    {/if}

    {if is_array($show_accessories)}
        <div class="card mb-3">
            <div class="card-header">{$label_products_accessories}</div>
            <div class="card-body">
                <div class="related-scroller">
                    {foreach $show_accessories as $product => $value}
                        <div class="card">
                            {if $value.image != ""}
                            <img src="{$value.image}" class="card-img-top" alt="{$value.title}"
                                 title="{$value.title}">
                            {/if}
                            <div class="card-body fs-6 lh-sm">
                                <h6 class="card-title mb-0">{$value.title}</h6>
                                <small>{$value.teaser}</small>
                                {if $value.class != 'active'}
                                    <a href="{$value.product_href}" class="stretched-link" title="{$value.title}"> </a>
                                {/if}
                            </div>
                        </div>
                    {/foreach}
                </div>
            </div>
        </div>
    {/if}

    {if is_array($show_related)}
        <div class="card mb-3">
            <div class="card-header">{$label_related_products}</div>
            <div class="card-body">
                <div class="related-scroller">
                    {foreach $show_related as $product => $value}
                        <div class="card">
                            {if $value.image != ""}
                            <img src="{$value.image}" class="card-img-top" alt="{$value.title}"
                                 title="{$value.title}">
                            {/if}
                            <div class="card-body fs-6 lh-sm">
                                <h6 class="card-title mb-0">{$value.title}</h6>
                                <small>{$value.teaser}</small>
                                {if $value.class != 'active'}
                                    <a href="{$value.product_href}" class="stretched-link" title="{$value.title}"> </a>
                                {/if}
                            </div>
                        </div>
                    {/foreach}
                </div>
            </div>
        </div>
    {/if}

    {if $product_snippet_text != ""}
        <div class="card mb-3">
            <div class="card-header">{$product_snippet_title}</div>
            <div class="card-body">
                {$product_snippet_text}
            </div>
        </div>
    {/if}

    {if $attachment_filename != ""}

        {if $alert_download != ""}
            {$alert_download}
        {/if}

        <form action="{$form_action}" method="POST">
        <div class="card mb-3">
            <div class="card-header">{$download_title}</div>
            <div class="card-body">{$download_text}</div>
            <div class="card-footer">
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#startDownloadModal"><i class="bi bi-download"></i> Download</button>
                <input type="hidden" name="get_attachment" value="{$product_id}">
            </div>
        </div>
            {$hidden_csrf_token}
        </form>
    {/if}

    {if $product_snippet_price != ""}
    <div class="card post-snippet-price mb-3">
        <div class="card-header">{$label_prices_snippet}</div>
        <div class="card-body">
            {$product_snippet_price}
        </div>
    </div>
    {/if}

    {if $show_voting == true}
        <div class="mb-3">
            {$hidden_csrf_token}
            <button class="btn btn-sm btn-outline-secondary" hx-post="/xhr/se/vote/" hx-swap="none" hx-include="[name='csrf_token']"
                    name="vote" value="up-product-{$product_id}" {$votes_status_up}>
                <i class="bi bi-hand-thumbs-up-fill"></i> <span hx-get="/xhr/se/votes/?section=s&upv={$product_id}" hx-swap="innerHTML" hx-trigger="load, update_votings_{$product_id} from:body">0</span>
            </button>
            <button class="btn btn-sm btn-outline-secondary" hx-post="/xhr/se/vote/" hx-swap="none" hx-include="[name='csrf_token']"
                    name="vote" value="dn-product-{$product_id}" {$votes_status_dn}>
                <i class="bi bi-hand-thumbs-down-fill"></i> <span hx-get="/xhr/se/votes/?section=s&dnv={$product_id}" hx-swap="innerHTML" hx-trigger="load, update_votings_{$product_id} from:body">0</span>
            </button>
        </div>
    {/if}

</div>

{if $se_snippet_downloading_modal != ""}
<div class="modal fade" id="startDownloadModal" tabindex="-1" aria-labelledby="startDownloadModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="exampleModalLabel">Download</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">

                    {$se_snippet_downloading_modal}

            </div>
        </div>
    </div>
</div>
{/if}

{foreach from=$product_plugin_actions item=action}
    {if $action.type == 'button'}
        <button type="submit"
                name="{$action.name|escape}"
                value="{$action.value|escape}"
                class="{$action.class|escape}">
            {$action.label|escape}
        </button>
    {elseif $action.type == 'link'}
        <a class="{$action.class|escape}" href="{$action.href|escape}">
            {$action.label|escape}
        </a>
    {/if}
{/foreach}

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
