-- Modelo de Base de Datos para Evento Gamers (PostgreSQL Recommended)
-- 1. Usuarios (Gamers / Admins)
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  avatar_url VARCHAR(255),
  role VARCHAR(20) DEFAULT 'user', -- 'user', 'admin', 'staff'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Juegos (Categorías: Tekken, Street Fighter, etc.)
CREATE TABLE games (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  image_url VARCHAR(255),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Torneos (Eventos específicos de cada juego)
CREATE TABLE tournaments (
  id SERIAL PRIMARY KEY,
  game_id INT REFERENCES games (id) ON DELETE CASCADE,
  title VARCHAR(150) NOT NULL,
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP,
  format VARCHAR(50), -- 'Single Elimination', 'Double Elimination', 'Round Robin'
  location VARCHAR(200),
  max_participants INT,
  status VARCHAR(20) DEFAULT 'upcoming', -- 'upcoming', 'ongoing', 'completed'
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Inscripciones (Usuarios registrados en torneos)
CREATE TABLE tournament_registrations (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users (id) ON DELETE CASCADE,
  tournament_id INT REFERENCES tournaments (id) ON DELETE CASCADE,
  registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'confirmed', -- 'confirmed', 'waitlist', 'cancelled'
  UNIQUE (user_id, tournament_id) -- Un usuario no puede registrarse doble vez al mismo torneo
);

-- 5. Equipos (Opcional, para torneos de equipos)
CREATE TABLE teams (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  captain_id INT REFERENCES users (id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Integrantes de Equipo
CREATE TABLE team_members (
  team_id INT REFERENCES teams (id) ON DELETE CASCADE,
  user_id INT REFERENCES users (id) ON DELETE CASCADE,
  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (team_id, user_id)
);

-- 7. Mensajes de Contacto (Desde el formulario web)
CREATE TABLE contact_messages (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  subject VARCHAR(200),
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices Recomendados para Performance
CREATE INDEX idx_users_email ON users (email);

CREATE INDEX idx_tournaments_status ON tournaments (status);

CREATE INDEX idx_registrations_user ON tournament_registrations (user_id);

CREATE INDEX idx_registrations_tournament ON tournament_registrations (tournament_id);
