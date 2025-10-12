-- Underground Terminal B2B Luxury Fashion & Cosmetics Platform
-- MySQL Data Initialization Script

-- Insert Users (Suppliers, Buyers, Designers)
INSERT INTO users (name, email, password, role, image_url, bio) VALUES
-- Luxury Fashion Suppliers
('Valentina Milano', 'valentina@milanolux.com', '$2a$10$1234567890abcdef', 'SUPPLIER', 'https://images.unsplash.com/photo-1494790108755-2616b612b047?w=200&h=200&fit=crop&crop=face', 'Exclusive Italian luxury fashion house specializing in haute couture and premium accessories.'),
('Marcus Sterling', 'marcus@sterlingcouture.com', '$2a$10$1234567890abcdef', 'SUPPLIER', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face', 'British heritage brand creating timeless luxury menswear and accessories.'),
('Sophia Chen', 'sophia@chendesigns.asia', '$2a$10$1234567890abcdef', 'SUPPLIER', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop&crop=face', 'Asian-inspired luxury fashion combining traditional craftsmanship with modern aesthetics.'),

-- Premium Cosmetics Suppliers
('Isabella Beauty', 'isabella@bellacosmetics.com', '$2a$10$1234567890abcdef', 'SUPPLIER', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=200&fit=crop&crop=face', 'Luxury cosmetics brand focused on organic, cruelty-free beauty products.'),
('Alexandre Parfums', 'alexandre@luxeparfums.fr', '$2a$10$1234567890abcdef', 'SUPPLIER', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face', 'French perfume house creating exclusive fragrances for discerning clientele.'),
('Celeste Skincare', 'celeste@celesteskin.com', '$2a$10$1234567890abcdef', 'SUPPLIER', 'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=200&h=200&fit=crop&crop=face', 'High-end skincare line using rare botanical ingredients and cutting-edge science.'),

-- Luxury Buyers
('David Hartwell', 'david@luxurybuyers.com', '$2a$10$1234567890abcdef', 'BUYER', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop&crop=face', 'Luxury retail buyer for high-end department stores and boutiques.'),
('Emma Richardson', 'emma@premiumretail.com', '$2a$10$1234567890abcdef', 'BUYER', 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=200&h=200&fit=crop&crop=face', 'Fashion buyer specializing in emerging luxury brands and exclusive collections.'),

-- Fashion Designers
('Lorenzo Vasquez', 'lorenzo@vasquezstudio.com', '$2a$10$1234567890abcdef', 'DESIGNER', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop&crop=face', 'Contemporary fashion designer creating avant-garde luxury pieces.');

-- Insert Luxury Fashion Products
INSERT INTO products (name, price, image_url, supplier_id, description, stock_level) VALUES
-- Valentina Milano Products (supplier_id: 1)
('Silk Palazzo Pants - Midnight Blue', 1250.00, 'https://images.unsplash.com/photo-1594633313593-bab3825d0caf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBmYXNoaW9uJTIwcGFudHN8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', 1, 'Luxurious silk palazzo pants in midnight blue, featuring flowing silhouette and exquisite Italian craftsmanship. Perfect for evening occasions.', 15),
('Cashmere Blazer - Champagne', 2850.00, 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBibGF6ZXJ8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', 1, 'Premium cashmere blazer in champagne hue with tailored fit and gold-tone hardware. Timeless elegance meets modern sophistication.', 8),
('Diamond Leaf Earrings', 4200.00, 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBqZXdlbHJ5fGVufDF8fHx8MTc1OTM0ODQ2M3ww&ixlib=rb-4.1.0&q=80&w=1080', 1, '18k white gold earrings featuring hand-set diamonds in delicate leaf pattern. Each piece is unique and crafted by master artisans.', 5),

-- Marcus Sterling Products (supplier_id: 2)
('Wool Overcoat - Charcoal', 3200.00, 'https://images.unsplash.com/photo-1544966503-7cc5ac882d5d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBtZW5zJTIwY29hdHxlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', 2, 'Heritage wool overcoat in charcoal grey, featuring traditional British tailoring with modern cut. Made from finest Scottish wool.', 12),
('Leather Oxford Shoes - Cognac', 1850.00, 'https://images.unsplash.com/photo-1549298916-b41d501d3772?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBzaG9lc3xlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', 2, 'Handcrafted leather Oxford shoes in rich cognac brown. Traditional Goodyear welted construction ensures durability and elegance.', 20),
('Silk Pocket Square - Navy Pattern', 125.00, 'https://images.unsplash.com/photo-1564859228273-274232fdb516?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBhY2Nlc3Nvcnl8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', 2, 'Pure silk pocket square with intricate navy pattern. The perfect finishing touch for formal and semi-formal occasions.', 35),

-- Sophia Chen Products (supplier_id: 3)
('Embroidered Kimono Jacket', 1650.00, 'https://images.unsplash.com/photo-1693452685198-86933eea720e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBmYXNoaW9uJTIwY29zbWV0aWNzJTIwcHJvZHVjdHN8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', 3, 'Silk kimono jacket with traditional hand-embroidered cherry blossom motifs. Modern interpretation of classic Asian elegance.', 10),
('Jade Pendant Necklace', 890.00, 'https://images.unsplash.com/photo-1611652022419-a9419f74343d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBuZWNrbGFjZXxlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', 3, 'Authentic jade pendant on 14k gold chain. Each jade stone is carefully selected for its quality and natural beauty.', 18),

-- Isabella Beauty Products (supplier_id: 4)
('Platinum Rejuvenating Serum', 450.00, 'https://images.unsplash.com/photo-1570194065650-d99fb4d8837a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBjb3NtZXRpY3N8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', 4, 'Revolutionary anti-aging serum with platinum peptides and organic botanicals. Clinically proven to reduce fine lines and boost radiance.', 25),
('24K Gold Face Mask', 320.00, 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBmYWNlJTIwbWFza3xlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', 4, 'Luxurious 24k gold-infused face mask that brightens, firms, and deeply nourishes skin. Contains collagen and hyaluronic acid.', 30),
('Diamond Dust Exfoliator', 280.00, 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBza2luY2FyZXxlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', 4, 'Gentle yet effective exfoliator with micronized diamond dust and pearl powder. Reveals smoother, more luminous skin.', 22),

-- Alexandre Parfums Products (supplier_id: 5)
('Noir Mystique Eau de Parfum', 350.00, 'https://images.unsplash.com/photo-1541643600914-78b084683601?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBwZXJmdW1lfGVufDF8fHx8MTc1OTM0ODQ2M3ww&ixlib=rb-4.1.0&q=80&w=1080', 5, 'Mysterious and alluring fragrance with notes of black orchid, amber, and sandalwood. Limited edition with only 500 bottles produced.', 15),
('Rose de Versailles Perfume', 520.00, 'https://images.unsplash.com/photo-1588405748880-12d1d2a59d75?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjByb3NlJTIwcGVyZnVtZXxlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', 5, 'Elegant rose fragrance inspired by French gardens. Features Bulgarian rose, peony, and white musk in a crystal bottle.', 12),

-- Celeste Skincare Products (supplier_id: 6)
('Caviar Repair Complex', 780.00, 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBza2luY2FyZSUyMGNyZWFtfGVufDF8fHx8MTc1OTM0ODQ2M3ww&ixlib=rb-4.1.0&q=80&w=1080', 6, 'Premium anti-aging cream with caviar extract and marine collagen. Intensive repair treatment for mature skin.', 20),
('Truffle Brightening Essence', 650.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBlc3NlbmNlfGVufDF8fHx8MTc1OTM0ODQ2M3ww&ixlib=rb-4.1.0&q=80&w=1080', 6, 'Rare truffle-infused essence that brightens and evens skin tone. Contains vitamin C and botanical extracts for radiant complexion.', 16),

-- Additional Luxury Items
('Crystal Chandelier Earrings', 2850.00, 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBjaGFuZGVsaWVyJTIwZWFycmluZ3N8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', 1, 'Statement chandelier earrings with Swarovski crystals and gold-plated setting. Perfect for red carpet events.', 6),
('Satin Evening Clutch', 720.00, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBjbHV0Y2h8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', 3, 'Elegant satin evening clutch with beaded details and chain strap. Available in midnight black and champagne gold.', 14),
('Platinum Eye Cream', 420.00, 'https://images.unsplash.com/photo-1556760544-74068565f05c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBleWUlMjBjcmVhbXxlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', 6, 'Luxurious eye cream with platinum peptides and retinol. Reduces dark circles and fine lines around delicate eye area.', 18);
