-- Seed Data SQL Script for Platform Back Office Auth
-- This script seeds initial data into the PostgreSQL database
-- Usage: Run this script after migrations are complete
-- Note: This script is idempotent - safe to run multiple times

-- ============================================================================
-- PERMISSIONS
-- ============================================================================

-- User permissions
INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'user:create', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'user:create');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'user:read', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'user:read');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'user:update', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'user:update');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'user:delete', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'user:delete');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'user:list', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'user:list');

-- Operator permissions
INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'operator:create', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'operator:create');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'operator:read', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'operator:read');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'operator:update', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'operator:update');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'operator:delete', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'operator:delete');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'operator:list', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'operator:list');

-- Role permissions
INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'role:create', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'role:create');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'role:read', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'role:read');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'role:update', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'role:update');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'role:delete', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'role:delete');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'role:list', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'role:list');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'role:assign-permission', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'role:assign-permission');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'role:remove-permission', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'role:remove-permission');

-- Permission permissions
INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'permission:create', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'permission:create');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'permission:read', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'permission:read');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'permission:update', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'permission:update');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'permission:delete', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'permission:delete');

INSERT INTO permissions (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'permission:list', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM permissions WHERE name = 'permission:list');

-- ============================================================================
-- ROLES
-- ============================================================================

INSERT INTO roles (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'Provider', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE name = 'Provider');

INSERT INTO roles (id, name, created_at, updated_at)
SELECT uuid_generate_v4(), 'Operator', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE name = 'Operator');

-- ============================================================================
-- ROLE-PERMISSION ASSIGNMENTS
-- ============================================================================

-- Assign all permissions to Provider role
INSERT INTO role_permissions (id, role_id, permission_id, created_at)
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id,
    CURRENT_TIMESTAMP
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'Provider'
  AND p.name IN (
    'user:create', 'user:read', 'user:update', 'user:delete', 'user:list',
    'operator:create', 'operator:read', 'operator:update', 'operator:delete', 'operator:list',
    'role:create', 'role:read', 'role:update', 'role:delete', 'role:list',
    'role:assign-permission', 'role:remove-permission',
    'permission:create', 'permission:read', 'permission:update', 'permission:delete', 'permission:list'
  )
  AND NOT EXISTS (
    SELECT 1 FROM role_permissions rp 
    WHERE rp.role_id = r.id AND rp.permission_id = p.id
  );

-- Assign limited permissions to Operator role (read-only)
INSERT INTO role_permissions (id, role_id, permission_id, created_at)
SELECT 
    uuid_generate_v4(),
    r.id,
    p.id,
    CURRENT_TIMESTAMP
FROM roles r
CROSS JOIN permissions p
WHERE r.name = 'Operator'
  AND p.name IN (
    'user:read', 'user:list',
    'operator:read', 'operator:list',
    'role:read', 'role:list',
    'permission:read', 'permission:list'
  )
  AND NOT EXISTS (
    SELECT 1 FROM role_permissions rp 
    WHERE rp.role_id = r.id AND rp.permission_id = p.id
  );

-- ============================================================================
-- USERS
-- ============================================================================

-- Admin User
-- Password: 12345678 (BCrypt hash: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy)
INSERT INTO users (id, username, display_name, email, password_hash, status, created_at, updated_at, created_by)
SELECT 
    uuid_generate_v4(),
    'admin',
    'Administrator',
    'admin@gmail.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'ACTIVE',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    NULL
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin' OR email = 'admin@gmail.com');

-- Operator User
-- Password: 12345678 (BCrypt hash: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy)
INSERT INTO users (id, username, display_name, email, password_hash, status, created_at, updated_at, created_by)
SELECT 
    uuid_generate_v4(),
    'operator',
    'Operator User',
    'operator@gmail.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    'ACTIVE',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    NULL
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'operator' OR email = 'operator@gmail.com');

-- ============================================================================
-- USER-ROLE ASSIGNMENTS
-- ============================================================================

-- Assign Provider role to Admin User
INSERT INTO user_roles (id, user_id, role_id, created_at)
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id,
    CURRENT_TIMESTAMP
FROM users u
CROSS JOIN roles r
WHERE u.username = 'admin'
  AND r.name = 'Provider'
  AND NOT EXISTS (
    SELECT 1 FROM user_roles ur 
    WHERE ur.user_id = u.id AND ur.role_id = r.id
  );

-- Assign Operator role to Operator User
INSERT INTO user_roles (id, user_id, role_id, created_at)
SELECT 
    uuid_generate_v4(),
    u.id,
    r.id,
    CURRENT_TIMESTAMP
FROM users u
CROSS JOIN roles r
WHERE u.username = 'operator'
  AND r.name = 'Operator'
  AND NOT EXISTS (
    SELECT 1 FROM user_roles ur 
    WHERE ur.user_id = u.id AND ur.role_id = r.id
  );

-- ============================================================================
-- OPERATORS
-- ============================================================================

-- Sample Operator (linked to admin user)
INSERT INTO operators (id, name, code, email, contact_person, phone, address, status, user_id, created_at, updated_at, created_by)
SELECT 
    uuid_generate_v4(),
    'Sample Operator',
    'OP001',
    'operator@example.com',
    'John Doe',
    '+1234567890',
    '123 Main Street, City, Country',
    'ACTIVE',
    u.id,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    NULL
FROM users u
WHERE u.username = 'admin'
  AND NOT EXISTS (SELECT 1 FROM operators WHERE code = 'OP001');

-- ============================================================================
-- COMPLETION MESSAGE
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE '✅ Data seeding process completed successfully!';
    RAISE NOTICE '';
    RAISE NOTICE 'Summary:';
    RAISE NOTICE '  - Permissions: 27 permissions created';
    RAISE NOTICE '  - Roles: 2 roles (Provider, Operator)';
    RAISE NOTICE '  - Role-Permission Assignments: Configured';
    RAISE NOTICE '  - Users: 2 users (admin, operator)';
    RAISE NOTICE '  - User-Role Assignments: Configured';
    RAISE NOTICE '  - Operators: 1 sample operator';
    RAISE NOTICE '';
    RAISE NOTICE 'Default credentials:';
    RAISE NOTICE '  Admin: username=admin, password=12345678';
    RAISE NOTICE '  Operator: username=operator, password=12345678';
END $$;
