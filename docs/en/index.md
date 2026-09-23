---
title: SwiftyEdit - flatDark Theme
description: Overview - The flatDark Theme
btn: Overview
group: themes
priority: 500
---

# The flatDark Theme

A dark, flat theme based on the default theme's templates. Same features as the
default theme (shop, blog, events, comments, wishlist, ...) built with
Bootstrap 5 and Bootstrap Icons.

This theme only ships the dark palette - there is no light/dark switch. A
matching light theme ("flatLight") is meant to be a separate theme, not a
runtime option of this one.

## Design rules

What makes this theme different from stock Bootstrap:

- No rounded corners anywhere (`$enable-rounded: false` in `_variables.scss`).
- Surfaces mostly share the page background rather than getting a fill of
  their own (cards, dropdowns, modals, ... all default to `var(--bs-body-bg)`
  in Bootstrap already) - separated only by a hairline border. Two
  deliberate, subtle exceptions: the navbar reads as very slightly *raised*
  and `#pageTeaser` as very slightly *sunken* (`$surface-raised-bg` /
  `$surface-sunken-bg`, both `color-mix()` off `$body-bg` rather than a fixed
  hex, so they stay correct relative to it).
- Contextual colors (secondary, success, warning, danger, info) are text/
  icon/border only, never a fill - see `_flat.scss`: alerts get a thin line
  on the left instead of a background, badges an outline instead of a fill,
  list-group/table contextual variants the same "line, not fill" treatment.
- Buttons are the one deliberate exception to that last rule: a filled
  button gets a thin bottom line *and* a subtle, dark, color-tinted fill
  (just enough to read as a surface, never Bootstrap's bright default fill).
  Outline buttons and pill buttons (`.rounded-pill`) keep a full contour
  instead of the bottom-only line - a single bottom edge on a fully rounded
  pill, or on a button whose entire point is the outline, doesn't read as a
  border at all.

## Skins (color variants)

The theme ships one extra color variant, Cyan, alongside the default pink -
pick it under Admin -> Addons -> Themes -> Stylesheet (see
`docs/v2/*/09-01-00-themes.md` in core for how that mechanism works in
general). `--bs-primary` is the only thing a skin changes; every other
contextual color stays fixed.

To add another skin:

1. Drop a new file in `src/scss/skins/`, e.g. `sunset.scss`:
   ```scss
   @import "skin-tokens";
   @include skin-tokens(#ff7a32);
   ```
2. `npm run build` - `discoverSkinEntries()` in `vite.config.js` picks it up
   automatically and compiles it to `dist/skins/sunset.css`. Nothing else to
   register anywhere; the ACP Stylesheet dropdown lists whatever `.css`
   files exist in `dist/skins/`.

Because most of this theme's own primary-colored elements (buttons, the
price badge, the buy-box line accent, ...) read `var(--bs-primary)` at
runtime rather than a baked-in hex - patched onto that in `_skin-compat.scss`
- a skin recolors the whole theme, not just Bootstrap's own components. If
you add a new primary-colored element to the theme later, check whether it
needs the same treatment there.

## Shop layout notes

- **Product listing** (`products-list.tpl`): a two-column card grid (one
  column on narrow screens), not the default theme's single-column list.
  The price is a badge overlaid on the product image's bottom-right corner
  (filled with primary, body-bg text - a second deliberate "filled"
  exception). There's no "add to cart" here - "More Informations" is the
  primary call to action (`btn-outline-primary`); adding to cart happens on
  the product's own page. The wishlist button is icon-only, its label lives
  in `title`/`aria-label` instead of visible text.
- **Product detail** (`products-display.tpl`): three regions - image / title
  + teaser / a narrow "buy box" (price, delivery time, add-to-cart form,
  wishlist), reordered per breakpoint with `order-md-*` rather than by DOM
  position, so the buy box sits directly after the image on mobile but
  becomes the right-hand column at `md`+. The buy box itself is
  transparent with a thin primary line on the left, the same accent
  language as alerts.
- The old tab bar for the product's text/features/volume-discounts/
  additional-texts/scope-of-delivery is now a stack of independent
  Bootstrap collapses - deliberately *not* a real accordion (no
  `data-bs-parent`), so opening one can't suddenly close another one you
  were in the middle of reading. The first one starts open.
- Variants, accessories and related products (`.related-scroller` in
  `_shop.scss`) are a horizontally scrolling strip of fixed-size cards
  instead of a grid that grows into more rows the more items there are -
  the count only ever changes how far there is to scroll.

You can find all frameworks and tools used in the `package.json` file,
you can find the SCSS/JS source in the `src` folder. See `todo.md` in this
theme's folder for planned follow-ups.

## Build

```
npm install
npm run build   # one-off production build into dist/
npm run dev     # rebuilds into dist/ on every file change
```
