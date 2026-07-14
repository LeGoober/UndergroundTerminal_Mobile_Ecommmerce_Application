-- Underground Terminal B2B Luxury Fashion & Cosmetics Platform
-- PostgreSQL Data Initialization Script
-- For use with the 'render' Spring profile
-- All passwords are "password123" (BCrypt encoded)

-- Insert Users (Suppliers, Buyers, Designers)
INSERT INTO users (name, email, password, role, image_url, bio)
SELECT 'Valentina Milano', 'valentina@milanolux.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'SUPPLIER', 'https://images.unsplash.com/photo-1494790108755-2616b612b047?w=200&h=200&fit=crop&crop=face', 'Exclusive Italian luxury fashion house specializing in haute couture and premium accessories.'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'valentina@milanolux.com');

INSERT INTO users (name, email, password, role, image_url, bio)
SELECT 'Marcus Sterling', 'marcus@sterlingcouture.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'SUPPLIER', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&crop=face', 'British heritage brand creating timeless luxury menswear and accessories.'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'marcus@sterlingcouture.com');

INSERT INTO users (name, email, password, role, image_url, bio)
SELECT 'Sophia Chen', 'sophia@chendesigns.asia', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'SUPPLIER', 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop&crop=face', 'Asian-inspired luxury fashion combining traditional craftsmanship with modern aesthetics.'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'sophia@chendesigns.asia');

INSERT INTO users (name, email, password, role, image_url, bio)
SELECT 'Isabella Beauty', 'isabella@bellacosmetics.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'SUPPLIER', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=200&fit=crop&crop=face', 'Luxury cosmetics brand focused on organic, cruelty-free beauty products.'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'isabella@bellacosmetics.com');

INSERT INTO users (name, email, password, role, image_url, bio)
SELECT 'Alexandre Parfums', 'alexandre@luxeparfums.fr', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'SUPPLIER', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face', 'French perfume house creating exclusive fragrances for discerning clientele.'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'alexandre@luxeparfums.fr');

INSERT INTO users (name, email, password, role, image_url, bio)
SELECT 'Celeste Skincare', 'celeste@celesteskin.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'SUPPLIER', 'https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=200&h=200&fit=crop&crop=face', 'High-end skincare line using rare botanical ingredients and cutting-edge science.'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'celeste@celesteskin.com');

INSERT INTO users (name, email, password, role, image_url, bio)
SELECT 'David Hartwell', 'david@luxurybuyers.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'BUYER', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop&crop=face', 'Luxury retail buyer for high-end department stores and boutiques.'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'david@luxurybuyers.com');

INSERT INTO users (name, email, password, role, image_url, bio)
SELECT 'Emma Richardson', 'emma@premiumretail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'BUYER', 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=200&h=200&fit=crop&crop=face', 'Fashion buyer specializing in emerging luxury brands and exclusive collections.'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'emma@premiumretail.com');

INSERT INTO users (name, email, password, role, image_url, bio)
SELECT 'Lorenzo Vasquez', 'lorenzo@vasquezstudio.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'DESIGNER', 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop&crop=face', 'Contemporary fashion designer creating avant-garde luxury pieces.'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE email = 'lorenzo@vasquezstudio.com');

-- Insert Luxury Fashion Products (Valentina Milano)
INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Silk Palazzo Pants - Midnight Blue', 1250.00, 'https://images.unsplash.com/photo-1594633313593-bab3825d0caf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBmYXNoaW9uJTIwcGFudHN8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'valentina@milanolux.com'), 'Luxurious silk palazzo pants in midnight blue, featuring flowing silhouette and exquisite Italian craftsmanship. Perfect for evening occasions.', 15
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Silk Palazzo Pants - Midnight Blue' AND supplier_id = (SELECT id FROM users WHERE email = 'valentina@milanolux.com'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Cashmere Blazer - Champagne', 2850.00, 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBibGF6ZXJ8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'valentina@milanolux.com'), 'Premium cashmere blazer in champagne hue with tailored fit and gold-tone hardware. Timeless elegance meets modern sophistication.', 8
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Cashmere Blazer - Champagne' AND supplier_id = (SELECT id FROM users WHERE email = 'valentina@milanolux.com'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Diamond Leaf Earrings', 4200.00, 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBqZXdlbHJ5fGVufDF8fHx8MTc1OTM0ODQ2M3ww&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'valentina@milanolux.com'), '18k white gold earrings featuring hand-set diamonds in delicate leaf pattern. Each piece is unique and crafted by master artisans.', 5
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Diamond Leaf Earrings' AND supplier_id = (SELECT id FROM users WHERE email = 'valentina@milanolux.com'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Crystal Chandelier Earrings', 2850.00, 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBjaGFuZGVsaWVyJTIwZWFycmluZ3N8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'valentina@milanolux.com'), 'Statement chandelier earrings with Swarovski crystals and gold-plated setting. Perfect for red carpet events.', 6
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Crystal Chandelier Earrings' AND supplier_id = (SELECT id FROM users WHERE email = 'valentina@milanolux.com'));

-- Insert Luxury Fashion Products (Marcus Sterling)
INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Wool Overcoat - Charcoal', 3200.00, 'https://images.unsplash.com/photo-1544966503-7cc5ac882d5d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBtZW5zJTIwY29hdHxlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'marcus@sterlingcouture.com'), 'Heritage wool overcoat in charcoal grey, featuring traditional British tailoring with modern cut. Made from finest Scottish wool.', 12
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Wool Overcoat - Charcoal' AND supplier_id = (SELECT id FROM users WHERE email = 'marcus@sterlingcouture.com'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Leather Oxford Shoes - Cognac', 1850.00, 'https://images.unsplash.com/photo-1549298916-b41d501d3772?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBzaG9lc3xlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'marcus@sterlingcouture.com'), 'Handcrafted leather Oxford shoes in rich cognac brown. Traditional Goodyear welted construction ensures durability and elegance.', 20
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Leather Oxford Shoes - Cognac' AND supplier_id = (SELECT id FROM users WHERE email = 'marcus@sterlingcouture.com'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Silk Pocket Square - Navy Pattern', 125.00, 'https://images.unsplash.com/photo-1564859228273-274232fdb516?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBhY2Nlc3Nvcnl8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'marcus@sterlingcouture.com'), 'Pure silk pocket square with intricate navy pattern. The perfect finishing touch for formal and semi-formal occasions.', 35
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Silk Pocket Square - Navy Pattern' AND supplier_id = (SELECT id FROM users WHERE email = 'marcus@sterlingcouture.com'));

-- Insert Luxury Fashion Products (Sophia Chen)
INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Embroidered Kimono Jacket', 1650.00, 'https://images.unsplash.com/photo-1693452685198-86933eea720e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBmYXNoaW9uJTIwY29zbWV0aWNzJTIwcHJvZHVjdHN8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'sophia@chendesigns.asia'), 'Silk kimono jacket with traditional hand-embroidered cherry blossom motifs. Modern interpretation of classic Asian elegance.', 10
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Embroidered Kimono Jacket' AND supplier_id = (SELECT id FROM users WHERE email = 'sophia@chendesigns.asia'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Jade Pendant Necklace', 890.00, 'https://images.unsplash.com/photo-1611652022419-a9419f74343d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBuZWNrbGFjZXxlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'sophia@chendesigns.asia'), 'Authentic jade pendant on 14k gold chain. Each jade stone is carefully selected for its quality and natural beauty.', 18
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Jade Pendant Necklace' AND supplier_id = (SELECT id FROM users WHERE email = 'sophia@chendesigns.asia'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Satin Evening Clutch', 720.00, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBjbHV0Y2h8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'sophia@chendesigns.asia'), 'Elegant satin evening clutch with beaded details and chain strap. Available in midnight black and champagne gold.', 14
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Satin Evening Clutch' AND supplier_id = (SELECT id FROM users WHERE email = 'sophia@chendesigns.asia'));

-- Insert Cosmetics Products (Isabella Beauty)
INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Platinum Rejuvenating Serum', 450.00, 'https://images.unsplash.com/photo-1570194065650-d99fb4d8837a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBjb3NtZXRpY3N8ZW58MXx8fHwxNzU5MzQ4NDYzfDA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'isabella@bellacosmetics.com'), 'Revolutionary anti-aging serum with platinum peptides and organic botanicals. Clinically proven to reduce fine lines and boost radiance.', 25
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Platinum Rejuvenating Serum' AND supplier_id = (SELECT id FROM users WHERE email = 'isabella@bellacosmetics.com'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT '24K Gold Face Mask', 320.00, 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBmYWNlJTIwbWFza3xlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'isabella@bellacosmetics.com'), 'Luxurious 24k gold-infused face mask that brightens, firms, and deeply nourishes skin. Contains collagen and hyaluronic acid.', 30
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = '24K Gold Face Mask' AND supplier_id = (SELECT id FROM users WHERE email = 'isabella@bellacosmetics.com'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Diamond Dust Exfoliator', 280.00, 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBza2luY2FyZXxlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'isabella@bellacosmetics.com'), 'Gentle yet effective exfoliator with micronized diamond dust and pearl powder. Reveals smoother, more luminous skin.', 22
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Diamond Dust Exfoliator' AND supplier_id = (SELECT id FROM users WHERE email = 'isabella@bellacosmetics.com'));

-- Insert Fragrance Products (Alexandre Parfums)
INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Noir Mystique Eau de Parfum', 350.00, 'https://images.unsplash.com/photo-1541643600914-78b084683601?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBwZXJmdW1lfGVufDF8fHx8MTc1OTM0ODQ2M3ww&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'alexandre@luxeparfums.fr'), 'Mysterious and alluring fragrance with notes of black orchid, amber, and sandalwood. Limited edition with only 500 bottles produced.', 15
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Noir Mystique Eau de Parfum' AND supplier_id = (SELECT id FROM users WHERE email = 'alexandre@luxeparfums.fr'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Rose de Versailles Perfume', 520.00, 'https://images.unsplash.com/photo-1588405748880-12d1d2a59d75?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjByb3NlJTIwcGVyZnVtZXxlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'alexandre@luxeparfums.fr'), 'Elegant rose fragrance inspired by French gardens. Features Bulgarian rose, peony, and white musk in a crystal bottle.', 12
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Rose de Versailles Perfume' AND supplier_id = (SELECT id FROM users WHERE email = 'alexandre@luxeparfums.fr'));

-- Insert Skincare Products (Celeste Skincare)
INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Caviar Repair Complex', 780.00, 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBza2luY2FyZSUyMGNyZWFtfGVufDF8fHx8MTc1OTM0ODQ2M3ww&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'celeste@celesteskin.com'), 'Premium anti-aging cream with caviar extract and marine collagen. Intensive repair treatment for mature skin.', 20
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Caviar Repair Complex' AND supplier_id = (SELECT id FROM users WHERE email = 'celeste@celesteskin.com'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Truffle Brightening Essence', 650.00, 'https://images.unsplash.com/photo-1556228720-195a672e8a03?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBlc3NlbmNlfGVufDF8fHx8MTc1OTM0ODQ2M3ww&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'celeste@celesteskin.com'), 'Rare truffle-infused essence that brightens and evens skin tone. Contains vitamin C and botanical extracts for radiant complexion.', 16
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Truffle Brightening Essence' AND supplier_id = (SELECT id FROM users WHERE email = 'celeste@celesteskin.com'));

INSERT INTO products (name, price, image_url, supplier_id, description, stock_level)
SELECT 'Platinum Eye Cream', 420.00, 'https://images.unsplash.com/photo-1556760544-74068565f05c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsdXh1cnklMjBleWUlMjBjcmVhbXxlbnwxfHx8fDE3NTkzNDg0NjN8MA&ixlib=rb-4.1.0&q=80&w=1080', (SELECT id FROM users WHERE email = 'celeste@celesteskin.com'), 'Luxurious eye cream with platinum peptides and retinol. Reduces dark circles and fine lines around delicate eye area.', 18
WHERE NOT EXISTS (SELECT 1 FROM products WHERE name = 'Platinum Eye Cream' AND supplier_id = (SELECT id FROM users WHERE email = 'celeste@celesteskin.com'));
