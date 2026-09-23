"use strict";

import '../scss/theme.scss';

import $ from 'jquery';
window.jQuery = $; window.$ = $;

import * as bootstrap from 'bootstrap/dist/js/bootstrap.bundle.js';

import GLightbox from 'glightbox';
window.glightbox = GLightbox;

import htmx from 'htmx.org/dist/htmx.esm';
window.htmx = htmx;

import { initWishlistSortable, copyWishlistLink } from './components/wishlist.js';
htmx.onLoad(function (content) {
    initWishlistSortable(content);
});
window.copyWishlistLink = copyWishlistLink;

import * as noUiSlider from 'nouislider';
window.noUiSlider = noUiSlider;

function registerElements() {
    const popoverTriggerList = document.querySelectorAll('[data-bs-toggle="popover"]');
    [...popoverTriggerList].map((el) => new bootstrap.Popover(el));

    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    [...tooltipTriggerList].map((el) => new bootstrap.Tooltip(el));

    // Instant-search modal (see navigation.tpl): focus its input as soon as
    // the modal has finished opening, and reset query + results on close so
    // the next open always starts from a clean state instead of showing the
    // previous search. Same as the default theme's frontend.js.
    const searchModal = document.getElementById('searchModal');
    if (searchModal) {
        const searchModalInput = searchModal.querySelector('#searchModalInput');

        searchModal.addEventListener('shown.bs.modal', function () {
            searchModalInput.focus();
        });

        searchModal.addEventListener('hidden.bs.modal', function () {
            searchModalInput.value = '';
            const suggestions = searchModal.querySelector('.search-suggestions');
            if (suggestions) {
                suggestions.classList.remove('show');
                suggestions.innerHTML = '';
            }
        });
    }
}

function adjustQuantity(step) {
    const input = document.getElementById('quantity');
    if (!input) {
        return;
    }
    input.stepUp(step);
    input.dispatchEvent(new Event('input', { bubbles: true }));
    input.dispatchEvent(new Event('change', { bubbles: true }));
}
window.adjustQuantity = adjustQuantity;

document.addEventListener('DOMContentLoaded', function () {

    GLightbox({
        selector: '.lightbox',
        touchNavigation: true,
        loop: true,
        autoplayVideos: true
    });

    registerElements();
    initWishlistSortable(document);

    // briefly bump the shopping cart icon when a product was added to the cart
    document.body.addEventListener('cart_item_added', function () {
        const cartIcon = document.querySelector('.shopping-cart-container');
        if (!cartIcon) {
            return;
        }

        cartIcon.classList.remove('cart-bump');
        void cartIcon.offsetWidth; // restart the animation on repeated triggers
        cartIcon.classList.add('cart-bump');
    });

    // shop: range filter sliders (min/max price, ...)
    const rangeSliders = document.querySelectorAll('.range-slider');

    rangeSliders.forEach(function (slider) {
        const filterSlug = slider.dataset.filterSlug;
        const min = parseFloat(slider.dataset.min);
        const max = parseFloat(slider.dataset.max);
        const currentMin = parseFloat(slider.dataset.currentMin);
        const currentMax = parseFloat(slider.dataset.currentMax);

        noUiSlider.create(slider, {
            start: [currentMin, currentMax],
            connect: true,
            range: {
                min: min,
                max: max
            },
            step: (max - min) / 10,
            format: {
                to: function (value) {
                    return Math.round(value);
                },
                from: function (value) {
                    return Number(value);
                }
            }
        });

        const display = document.getElementById('range-' + filterSlug + '-display');

        slider.noUiSlider.on('update', function (values) {
            if (display) {
                display.textContent = values[0] + ' - ' + values[1];
            }
        });

        slider.noUiSlider.on('change', function (values) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set(filterSlug, values[0] + '-' + values[1]);
            urlParams.delete('page'); // reset pagination
            window.location.search = urlParams.toString();
        });
    });
});
