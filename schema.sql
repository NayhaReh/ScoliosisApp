CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(200) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    name VARCHAR (100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE devices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device_uid VARCHAR(100) UNIQUE NOT NULL,
    user_id INT,
    battery_level INT, -- Current level
    last_seen TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE sensor_readings(
    id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT NOT NULL,
    battery_level INT, -- Tracks battery over time as a trend
    strain_gauge FLOAT,
    piezoelectric FLOAT,
    displacement FLOAT,
    worn BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cached_upload BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (device_id) REFERENCES devices(id), INDEX(device_id, recorded_at)
    -- id for device as foreign key
    -- we need time for reading
    -- sensor reading
);

CREATE TABLE user_targets(
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    target_tension FLOAT,
    daily_wear_hours FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    device_id INT,
    type VARCHAR(50), -- low_battery, no_signal, low_wear, tension_out
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (device_id) REFERENCES devices(id)
);

CREATE TABLE error_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT,
    error_type VARCHAR(100),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------------------------------------

CREATE INDEX idx_user_resolved ON alerts(user_id, resolved);