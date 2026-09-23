<header id="pageHeader">

    <div class="header-hero">
    <div class="header-decoration" aria-hidden="true"></div>

    <div class="container py-3 position-relative">

        <div class="header-bar d-flex flex-wrap align-items-center justify-content-between gap-2">

            <a href="/" class="site-brand d-flex align-items-center text-decoration-none" title="{$prefs_pagetitle}">
                {if {$page_logo} != ''}
                    <img src="{$page_logo}" alt="Logo" class="site-logo">
                {/if}
                <span class="site-title">{$prefs_pagetitle}{if $prefs_pagesubtitle != ''} <small class="site-subtitle d-none d-md-inline">{$prefs_pagesubtitle}</small>{/if}</span>
            </a>

            <div class="header-utility-bar d-flex flex-wrap align-items-center">

                {if $show_shopping_cart == true}
                    <div class="shopping-cart-container">
                        <a href="{$shopping_cart_uri}" title="{$lang_label_shopping_cart}">
                            <i class="bi bi-basket-fill"></i>
                        <span id="shopping-cart-trigger"
                         hx-get="/xhr/se/counter/?sc_items"
                         hx-trigger="load, update_user_status from:body"
                         hx-swap="innerHTML">0</span>
                        </a>
                    </div>
                {/if}

                {if $social_media_block != ''}
                    {include file='socialmedia.tpl'}
                {/if}

                <div class="user-status-container">
                    {if $smarty.session.user_class == "administrator"}
                        <button class="btn btn-link btn-sm" type="button" data-bs-toggle="offcanvas" data-bs-target="#adminHelpersOffcanvas" aria-controls="adminHelpersOffcanvas" title="{$lang_button_acp}">
                            <i class="bi bi-tools"></i>
                        </button>
                    {/if}

                    <div class="dropdown d-inline-block">
                        <button class="btn btn-link btn-sm dropdown-toggle" id="userBoxToggle" type="button" aria-expanded="false" data-bs-toggle="dropdown" data-bs-display="static">
                            <i class="bi bi-person-circle"></i>
                        </button>
                        <div class="dropdown-menu dropdown-menu-end p-2" aria-labelledby="userBoxToggle" style="min-width: 280px;">
                            <div id="user-box"
                                 hx-get="/xhr/se/statusbox/"
                                 hx-trigger="load, update_user_status"
                                 hx-swap="innerHTML">
                                <div class="d-flex align-items-center htmx-indicator">
                                    <div class="spinner-border spinner-border-sm me-2" role="status"></div>
                                    <span class="sr-only">{$lang_loading}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {if $smarty.session.user_class == "administrator"}
                    <div class="offcanvas offcanvas-end" tabindex="-1" id="adminHelpersOffcanvas" aria-labelledby="adminHelpersOffcanvasLabel">
                        <div class="offcanvas-header">
                            <h5 class="offcanvas-title" id="adminHelpersOffcanvasLabel">{$lang_button_acp}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                        </div>
                        <div class="offcanvas-body">
                            {include file='admin_helpers.tpl'}
                        </div>
                    </div>
                {/if}

            </div>

        </div>

    </div>
    </div>
</header>

{* The navbar is a sibling of <header>, not nested inside it: position:sticky
   is constrained to stay within its parent's box, and <header> alone (hero +
   nav) is too short to give it any room to actually stick while the page
   content below scrolls. *}
{include file='navigation.tpl'}

{if $teaser_text}
    <div id="pageTeaser">
        <div class="container">
        {$teaser_text}
        </div>
    </div>
{/if}
