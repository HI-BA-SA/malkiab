import 'package:flutter/material.dart';

import '../jsonparse/home_content.dart';
import '../jsonparse/product_parse.dart';

/// Curated demo catalogue for the malkiab boutique.
/// All image URLs are verified (Pexels CDN, 200 OK).
class MockCatalog {
  MockCatalog._();

  static const String _u = '?auto=compress&cs=tinysrgb&w=900';

  // ---------------------------------------------------------------- banners
  static const List<BannerItem> banners = [
    BannerItem(
      title: 'The Velvet Rose Edit',
      subtitle: 'Satin lips, new-season shades',
      imageUrl:
          'https://images.pexels.com/photos/374643/pexels-photo-374643.jpeg$_u',
      category: 'Lips',
    ),
    BannerItem(
      title: 'Chromatic Eyes',
      subtitle: 'Palettes made for golden hour',
      imageUrl:
          'https://images.pexels.com/photos/396129/pexels-photo-396129.jpeg$_u',
      category: 'Eyes',
    ),
    BannerItem(
      title: 'Skin First Rituals',
      subtitle: 'Glow begins with care',
      imageUrl:
          'https://images.pexels.com/photos/7446659/pexels-photo-7446659.jpeg$_u',
      category: 'Skincare',
    ),
    BannerItem(
      title: 'Rosé Eau de Parfum',
      subtitle: 'Our signature scent',
      imageUrl:
          'https://images.pexels.com/photos/15097440/pexels-photo-15097440.jpeg$_u',
      category: 'Fragrance',
    ),
  ];

  // ------------------------------------------------------------- categories
  static const List<CategoryItem> categories = [
    CategoryItem(name: 'Lips', icon: Icons.brush_outlined),
    CategoryItem(name: 'Face', icon: Icons.face_outlined),
    CategoryItem(name: 'Eyes', icon: Icons.remove_red_eye_outlined),
    CategoryItem(name: 'Skincare', icon: Icons.spa_outlined),
    CategoryItem(name: 'Tools', icon: Icons.brush),
    CategoryItem(name: 'Fragrance', icon: Icons.local_florist_outlined),
    CategoryItem(name: 'Nails', icon: Icons.diamond_outlined),
  ];

  // ----------------------------------------------------------- collections
  static const List<CollectionItem> collections = [
    CollectionItem(
      title: 'Date Night',
      subtitle: 'Lips that linger',
      imageUrl:
          'https://images.pexels.com/photos/7290642/pexels-photo-7290642.jpeg$_u',
      keyWord: 'lip',
    ),
    CollectionItem(
      title: 'Everyday Glow',
      subtitle: 'Skin with a lit-from-within finish',
      imageUrl:
          'https://images.pexels.com/photos/14581433/pexels-photo-14581433.jpeg$_u',
      keyWord: 'glow',
    ),
    CollectionItem(
      title: 'Bold Eyes',
      subtitle: 'From soft lash to smoked-out liner',
      imageUrl:
          'https://images.pexels.com/photos/15669271/pexels-photo-15669271.jpeg$_u',
      keyWord: 'eye',
    ),
  ];

  // -------------------------------------------------------------- products
  static const List<ProductEntity> products = [
    // ------------------------------------------------------------- Lips (6)
    ProductEntity(
      id: 1,
      name: 'Velvet Rose Satin Lipstick',
      price: '26.00',
      imageUrl:
          'https://images.pexels.com/photos/374643/pexels-photo-374643.jpeg$_u',
      productType: 'lipstick',
      category: 'Lips',
      brand: 'malkiab',
      rating: 4.8,
      reviewCount: 412,
      badge: 'Bestseller',
      isFeatured: true,
      shades: ['#B76E79', '#9C4F5B', '#D98E8E', '#7E3B47', '#C9898E'],
      description:
          'A satin-matte lipstick that glides on like balm and wears like couture. '
          'Rose-derived pigments keep lips soft, hydrated and unmistakably you.',
      gallery: [
        'https://images.pexels.com/photos/7290642/pexels-photo-7290642.jpeg$_u',
        'https://images.pexels.com/photos/3951888/pexels-photo-3951888.jpeg$_u',
      ],
    ),
    ProductEntity(
      id: 2,
      name: 'Blur Matte Lip Cream',
      price: '22.00',
      imageUrl:
          'https://images.pexels.com/photos/7290642/pexels-photo-7290642.jpeg$_u',
      productType: 'lip cream',
      category: 'Lips',
      brand: 'malkiab',
      rating: 4.6,
      reviewCount: 288,
      badge: 'New',
      isFeatured: true,
      shades: ['#C9707A', '#A94B5A', '#E0A0A0', '#8C3A4A'],
      description:
          'Weightless liquid colour with a soft-focus finish. One swipe blurs '
          'lip lines for a plush, airbrushed pout that lasts up to 12 hours.',
      gallery: [
        'https://images.pexels.com/photos/34775443/pexels-photo-34775443.jpeg$_u',
      ],
    ),
    ProductEntity(
      id: 3,
      name: 'Glow Peptide Lip Oil',
      price: '19.00',
      imageUrl:
          'https://images.pexels.com/photos/3951888/pexels-photo-3951888.jpeg$_u',
      productType: 'lip oil',
      category: 'Lips',
      brand: 'malkiab',
      rating: 4.9,
      reviewCount: 531,
      badge: 'Bestseller',
      shades: ['#E8B4B8', '#D98E9A', '#C9707A'],
      description:
          'A cushiony lip oil infused with peptides and jojoba. Sheer tint, '
          'mirror shine and a plumping tingle in one doe-foot swipe.',
    ),
    ProductEntity(
      id: 4,
      name: 'Soft Focus Lip Balm Tint',
      price: '16.00',
      imageUrl:
          'https://images.pexels.com/photos/34775443/pexels-photo-34775443.jpeg$_u',
      productType: 'lip balm',
      category: 'Lips',
      brand: 'malkiab',
      rating: 4.5,
      reviewCount: 176,
      shades: ['#D9A0A0', '#C9707A', '#B76E79'],
      description:
          'Your everyday balm with a whisper of colour. Shea butter and '
          'hyaluronic acid keep lips comfortable from morning to midnight.',
    ),
    ProductEntity(
      id: 5,
      name: 'Couture Lipstick Trio',
      price: '58.00',
      imageUrl:
          'https://images.pexels.com/photos/23349900/pexels-photo-23349900.jpeg$_u',
      productType: 'lipstick set',
      category: 'Lips',
      brand: 'Malkiab Studio',
      rating: 4.7,
      reviewCount: 94,
      badge: 'Gift',
      shades: ['#B76E79', '#7E3B47', '#D98E8E'],
      description:
          'Three statement bullets in a rose-gold keepsake case. Nude, rose '
          'and berry — the full velvet wardrobe for lips.',
    ),
    ProductEntity(
      id: 6,
      name: 'Prism Liquid Lipstick',
      price: '24.00',
      imageUrl:
          'https://images.pexels.com/photos/17907225/pexels-photo-17907225.jpeg$_u',
      productType: 'liquid lipstick',
      category: 'Lips',
      brand: 'malkiab',
      rating: 4.4,
      reviewCount: 143,
      badge: 'Sale',
      isFeatured: true,
      shades: ['#9C4F5B', '#C9898E', '#5E2A33'],
      description:
          'Liquid colour with a prismatic sheen that catches the light. '
          'Non-drying formula sets transfer-proof in sixty seconds.',
    ),

    // ------------------------------------------------------------ Face (5)
    ProductEntity(
      id: 7,
      name: 'Second Skin Glow Foundation',
      price: '38.00',
      imageUrl:
          'https://images.pexels.com/photos/14581433/pexels-photo-14581433.jpeg$_u',
      productType: 'foundation',
      category: 'Face',
      brand: 'malkiab',
      rating: 4.7,
      reviewCount: 622,
      badge: 'Bestseller',
      isFeatured: true,
      shades: [
        '#F2D3B8',
        '#E5BC98',
        '#D2A177',
        '#B98356',
        '#8E5F3C',
        '#5F3E28',
      ],
      description:
          'A breathable, buildable foundation with a luminous finish. '
          '30-hour wear that moves with your skin instead of sitting on it.',
      gallery: [
        'https://images.pexels.com/photos/7290123/pexels-photo-7290123.jpeg$_u',
      ],
    ),
    ProductEntity(
      id: 8,
      name: 'Airbrush Velvet Powder',
      price: '32.00',
      imageUrl:
          'https://images.pexels.com/photos/7290123/pexels-photo-7290123.jpeg$_u',
      productType: 'powder',
      category: 'Face',
      brand: 'malkiab',
      rating: 4.5,
      reviewCount: 205,
      shades: ['#F2D3B8', '#D2A177', '#B98356'],
      description:
          'A featherlight finishing powder that blurs pores and sets makeup '
          'without ever looking cakey or flat.',
    ),
    ProductEntity(
      id: 9,
      name: 'Cloud Blush Cream Blush',
      price: '24.00',
      imageUrl:
          'https://images.pexels.com/photos/35341712/pexels-photo-35341712.jpeg$_u',
      productType: 'blush',
      category: 'Face',
      brand: 'malkiab',
      rating: 4.8,
      reviewCount: 349,
      badge: 'New',
      isFeatured: true,
      shades: ['#E8A0A8', '#D97B82', '#C9707A', '#B85C6A'],
      description:
          'A whipped cream blush that melts into skin for a lit-from-within '
          'flush. Tap it on cheeks and lips for a monochrome moment.',
    ),
    ProductEntity(
      id: 10,
      name: 'Radiance Tip Concealer',
      price: '22.00',
      imageUrl:
          'https://images.pexels.com/photos/22481931/pexels-photo-22481931.jpeg$_u',
      productType: 'concealer',
      category: 'Face',
      brand: 'malkiab',
      rating: 4.6,
      reviewCount: 287,
      shades: ['#F5DECB', '#E5C5A5', '#CFA984', '#A97F5A'],
      description:
          'Creamy, crease-proof coverage that brightens under-eyes and melts '
          'over blemishes. Never heavy, never mask-like.',
    ),
    ProductEntity(
      id: 11,
      name: 'Luminous Setting Mist',
      price: '26.00',
      imageUrl:
          'https://images.pexels.com/photos/6568231/pexels-photo-6568231.jpeg$_u',
      productType: 'setting spray',
      category: 'Face',
      brand: 'malkiab',
      rating: 4.7,
      reviewCount: 418,
      badge: 'Bestseller',
      description:
          'A fine, skin-loving mist that locks makeup in place and melts '
          'away any powdery finish for a fresh, dewy look.',
    ),

    // ------------------------------------------------------------ Eyes (6)
    ProductEntity(
      id: 12,
      name: 'Silk Volume Mascara',
      price: '24.00',
      imageUrl:
          'https://images.pexels.com/photos/15669271/pexels-photo-15669271.jpeg$_u',
      productType: 'mascara',
      category: 'Eyes',
      brand: 'malkiab',
      rating: 4.8,
      reviewCount: 701,
      badge: 'Bestseller',
      isFeatured: true,
      description:
          'Soft-grip wands build feathery, silk-drama lashes without clumps. '
          'Smudge-proof, flake-proof, and easy to remove with warm water.',
      gallery: [
        'https://images.pexels.com/photos/36930354/pexels-photo-36930354.jpeg$_u',
      ],
    ),
    ProductEntity(
      id: 13,
      name: 'Mega Lash Flutter Mascara',
      price: '22.00',
      imageUrl:
          'https://images.pexels.com/photos/36930354/pexels-photo-36930354.jpeg$_u',
      productType: 'mascara',
      category: 'Eyes',
      brand: 'malkiab',
      rating: 4.5,
      reviewCount: 356,
      shades: ['#1A1A1A', '#4A2C2A', '#3B2C4A'],
      description:
          'An hourglass brush loads every tiny lash for maximum flutter. '
          'Buildable volume from first coat to full-on fringe.',
    ),
    ProductEntity(
      id: 14,
      name: 'Nude Spectrum Eyeshadow Palette',
      price: '46.00',
      imageUrl:
          'https://images.pexels.com/photos/32388555/pexels-photo-32388555.jpeg$_u',
      productType: 'eyeshadow palette',
      category: 'Eyes',
      brand: 'Malkiab Studio',
      rating: 4.9,
      reviewCount: 588,
      badge: 'Bestseller',
      isFeatured: true,
      description:
          'Twelve seamless neutrals — matte, satin and shimmer — that blend '
          'themselves. Your desk-to-dinner wardrobe for eyes.',
      gallery: [
        'https://images.pexels.com/photos/396129/pexels-photo-396129.jpeg$_u',
        'https://images.pexels.com/photos/1083932/pexels-photo-1083932.jpeg$_u',
      ],
    ),
    ProductEntity(
      id: 15,
      name: 'Chromatic Pop Palette',
      price: '48.00',
      imageUrl:
          'https://images.pexels.com/photos/396129/pexels-photo-396129.jpeg$_u',
      productType: 'eyeshadow palette',
      category: 'Eyes',
      brand: 'Malkiab Studio',
      rating: 4.7,
      reviewCount: 231,
      badge: 'New',
      shades: [],
      description:
          'Twenty vivid, high-pigment shades for when subtlety is not on the '
          'agenda. Blendable colour that plays as hard as you do.',
      gallery: [
        'https://images.pexels.com/photos/32388555/pexels-photo-32388555.jpeg$_u',
      ],
    ),
    ProductEntity(
      id: 16,
      name: 'Precision Brow Sculpt Pencil',
      price: '20.00',
      imageUrl:
          'https://images.pexels.com/photos/17156387/pexels-photo-17156387.jpeg$_u',
      productType: 'brow pencil',
      category: 'Eyes',
      brand: 'malkiab',
      rating: 4.6,
      reviewCount: 198,
      shades: ['#4A3728', '#2E2320', '#6B5344', '#8C7A6B'],
      description:
          'A micro-tip pencil that draws hair-like strokes with a spoolie on '
          'the other end. Arch perfection in under a minute.',
    ),
    ProductEntity(
      id: 17,
      name: 'Velvet Glide Eyeliner',
      price: '18.00',
      imageUrl:
          'https://images.pexels.com/photos/1083932/pexels-photo-1083932.jpeg$_u',
      productType: 'eyeliner',
      category: 'Eyes',
      brand: 'malkiab',
      rating: 4.4,
      reviewCount: 167,
      badge: 'Sale',
      shades: ['#1A1A1A', '#3B2C4A', '#4A2C2A', '#1F3A5F'],
      description:
          'A glide-on kohl that stays put. Waterproof, buildable and '
          'smudgeable in the first thirty seconds for a soft smoky eye.',
    ),

    // -------------------------------------------------------- Skincare (5)
    ProductEntity(
      id: 18,
      name: 'Rose Water Hydrating Cream',
      price: '42.00',
      imageUrl:
          'https://images.pexels.com/photos/6925480/pexels-photo-6925480.jpeg$_u',
      productType: 'moisturizer',
      category: 'Skincare',
      brand: 'malkiab',
      rating: 4.9,
      reviewCount: 467,
      badge: 'Bestseller',
      isFeatured: true,
      description:
          'A cloud-soft cream with Bulgarian rose water and ceramides that '
          'quenches skin for 72 hours — no grease, just glow.',
      gallery: [
        'https://images.pexels.com/photos/33756874/pexels-photo-33756874.jpeg$_u',
      ],
    ),
    ProductEntity(
      id: 19,
      name: 'Overnight Recovery Mask',
      price: '36.00',
      imageUrl:
          'https://images.pexels.com/photos/33756874/pexels-photo-33756874.jpeg$_u',
      productType: 'face mask',
      category: 'Skincare',
      brand: 'malkiab',
      rating: 4.7,
      reviewCount: 254,
      badge: 'New',
      description:
          'A sleeping mask with niacinamide and squalane that works while '
          'you dream. Wake up to bouncy, rested, restaurant-menu skin.',
    ),
    ProductEntity(
      id: 20,
      name: 'Hydra Glow Serum',
      price: '44.00',
      imageUrl:
          'https://images.pexels.com/photos/7446659/pexels-photo-7446659.jpeg$_u',
      productType: 'serum',
      category: 'Skincare',
      brand: 'malkiab',
      rating: 4.8,
      reviewCount: 519,
      badge: 'Bestseller',
      isFeatured: true,
      description:
          'A weightless gel-serum with hyaluronic acid and vitamin C that '
          'layers under anything and makes everything else work harder.',
    ),
    ProductEntity(
      id: 21,
      name: 'Gentle Micellar Cleanser',
      price: '20.00',
      imageUrl:
          'https://images.pexels.com/photos/4612122/pexels-photo-4612122.jpeg$_u',
      productType: 'cleanser',
      category: 'Skincare',
      brand: 'malkiab',
      rating: 4.6,
      reviewCount: 302,
      description:
          'Makeup melts away without rubbing. Micelles lift grime and SPF '
          'while glycerin keeps the barrier happy.',
    ),
    ProductEntity(
      id: 22,
      name: 'Nourishing Body Elixir',
      price: '34.00',
      imageUrl:
          'https://images.pexels.com/photos/23228944/pexels-photo-23228944.jpeg$_u',
      productType: 'body oil',
      category: 'Skincare',
      brand: 'malkiab',
      rating: 4.5,
      reviewCount: 121,
      shades: [],
      description:
          'A dry oil of rosehip and argan that sinks in fast, leaving skin '
          'satiny with a subtle, candlelit sheen.',
    ),

    // ------------------------------------------------------------ Tools (4)
    ProductEntity(
      id: 23,
      name: 'Essential Face Brush Set',
      price: '54.00',
      imageUrl:
          'https://images.pexels.com/photos/6148/brush-makeup-make-up-brushes.jpg$_u',
      productType: 'brush set',
      category: 'Tools',
      brand: 'Malkiab Studio',
      rating: 4.8,
      reviewCount: 276,
      badge: 'Gift',
      isFeatured: true,
      description:
          'Five vegan-bristle brushes with tapered handles for flawless '
          'buffing, blending and detail work. Roll them up and go.',
      gallery: [
        'https://images.pexels.com/photos/5352628/pexels-photo-5352628.jpeg$_u',
      ],
    ),
    ProductEntity(
      id: 24,
      name: 'Pro Powder Brush',
      price: '28.00',
      imageUrl:
          'https://images.pexels.com/photos/5352628/pexels-photo-5352628.jpeg$_u',
      productType: 'brush',
      category: 'Tools',
      brand: 'Malkiab Studio',
      rating: 4.7,
      reviewCount: 143,
      description:
          'A plush, densely packed brush that sweeps on powder and blends '
          'away edges for a soft-focus finish.',
    ),
    ProductEntity(
      id: 25,
      name: 'Velvet Blending Sponges',
      price: '16.00',
      imageUrl:
          'https://images.pexels.com/photos/36931056/pexels-photo-36931056.jpeg$_u',
      productType: 'beauty sponge',
      category: 'Tools',
      brand: 'malkiab',
      rating: 4.5,
      reviewCount: 224,
      badge: 'New',
      shades: ['#C9898E', '#E8B4B8', '#F5DECB'],
      description:
          'A duo of egg-soft sponges — one for base, one for detail. Use '
          'damp for a second-skin blend every single time.',
    ),
    ProductEntity(
      id: 26,
      name: 'Atelier Makeup Pouch',
      price: '30.00',
      imageUrl:
          'https://images.pexels.com/photos/37728173/pexels-photo-37728173.jpeg$_u',
      productType: 'makeup bag',
      category: 'Tools',
      brand: 'Malkiab Studio',
      rating: 4.6,
      reviewCount: 88,
      description:
          'A wipe-clean quilted pouch with room for your whole routine — '
          'and a rose-gold zip that never snags.',
    ),

    // -------------------------------------------------------- Fragrance (3)
    ProductEntity(
      id: 27,
      name: 'Rosé Eau de Parfum',
      price: '68.00',
      imageUrl:
          'https://images.pexels.com/photos/15097440/pexels-photo-15097440.jpeg$_u',
      productType: 'perfume',
      category: 'Fragrance',
      brand: 'malkiab',
      rating: 4.9,
      reviewCount: 341,
      badge: 'Bestseller',
      isFeatured: true,
      description:
          'Our signature scent: damask rose, pink pepper and warm amber. '
          'Flirty at first spritz, unforgettable by midnight.',
      gallery: [
        'https://images.pexels.com/photos/15007560/pexels-photo-15007560.jpeg$_u',
      ],
    ),
    ProductEntity(
      id: 28,
      name: 'Velvet Bloom Eau de Parfum',
      price: '64.00',
      imageUrl:
          'https://images.pexels.com/photos/15007560/pexels-photo-15007560.jpeg$_u',
      productType: 'perfume',
      category: 'Fragrance',
      brand: 'malkiab',
      rating: 4.7,
      reviewCount: 187,
      badge: 'New',
      description:
          'Tuberose and jasmine wrapped in cashmere musk — a bouquet that '
          'feels like silk against the skin.',
    ),
    ProductEntity(
      id: 29,
      name: 'Amber Kiss Perfume Oil',
      price: '38.00',
      imageUrl:
          'https://images.pexels.com/photos/15096784/pexels-photo-15096784.jpeg$_u',
      productType: 'perfume oil',
      category: 'Fragrance',
      brand: 'malkiab',
      rating: 4.6,
      reviewCount: 96,
      shades: [],
      description:
          'A roll-on perfume oil of amber, vanilla and sandalwood. Intimate, '
          'skin-scent warmth that lasts all day.',
    ),

    // ------------------------------------------------------------ Nails (3)
    ProductEntity(
      id: 30,
      name: 'Gel Couture Nail Lacquer',
      price: '15.00',
      imageUrl:
          'https://images.pexels.com/photos/7066298/pexels-photo-7066298.jpeg$_u',
      productType: 'nail polish',
      category: 'Nails',
      brand: 'malkiab',
      rating: 4.5,
      reviewCount: 209,
      badge: 'New',
      isFeatured: true,
      shades: ['#E63966', '#FFD60A', '#2EC4B6', '#F77F00', '#457B9D'],
      description:
          'Salon gel-shine colour in one coat, no lamp required. Chip-resistant '
          'wear for up to ten days with our top coat.',
    ),
    ProductEntity(
      id: 31,
      name: 'Playful Pigment Nail Set',
      price: '36.00',
      imageUrl:
          'https://images.pexels.com/photos/16041439/pexels-photo-16041439.jpeg$_u',
      productType: 'nail polish set',
      category: 'Nails',
      brand: 'Malkiab Studio',
      rating: 4.6,
      reviewCount: 74,
      shades: ['#E63966', '#FFD60A', '#2EC4B6', '#F77F00', '#2B2D42'],
      description:
          'Four mini lacquers for mixing, matching and main-character '
          'manicures. Quick-dry formula, high-gloss finish.',
    ),
    ProductEntity(
      id: 32,
      name: 'Glass Shine Top Coat',
      price: '14.00',
      imageUrl:
          'https://images.pexels.com/photos/22668317/pexels-photo-22668317.jpeg$_u',
      productType: 'top coat',
      category: 'Nails',
      brand: 'malkiab',
      rating: 4.7,
      reviewCount: 158,
      badge: 'Bestseller',
      description:
          'A mirror-bright top coat that seals colour and resists chips. '
          'Dries in sixty seconds to a glassy, gel-like finish.',
    ),
  ];

  static List<ProductEntity> byCategory(String category) => products
      .where((p) => p.category.toLowerCase() == category.toLowerCase())
      .toList();

  static List<ProductEntity> get featured =>
      products.where((p) => p.isFeatured).toList();
}
