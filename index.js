require('dotenv').config();
const express = require('express');
const multer = require('multer');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const fs = require('fs');
const http = require('http');
const socketIo = require('socket.io');
const path = require('path');
const { validationResult } = require("express-validator");
const { insertData } = require("./modules/insertIntoDb");
const validateForm = require("./modules/validation");
const { checkEmailExistence } = require("./modules/checkEmail.js");
const mysql = require('mysql2'); // ✅ Use the promise version
const cors = require("cors");
const session = require("express-session");

// Initialize Express app
const app = express();

app.use(cors());
app.use(bodyParser.json());


// Create server and socket.io instance after app initialization
const server = http.createServer(app);
const io = socketIo(server);

// Middleware setup
app.use(express.json());
app.use(cors({ credentials: true, origin: 'http://localhost:3000' })); 
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(session({
    secret: "secret-key",
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false }
}));

// Set static file directories


const PORT = 3000;

app.use(express.urlencoded({ extended: true }));
app.use(express.json()); // To handle JSON request bodies
app.use(express.static(path.join(__dirname, 'public')));

// Serve static files from the 'images' folder
app.use('/3D_Images', express.static(path.join(__dirname, '3D_Images')));
// Serve static files from the 'images' folder
app.use('/images', express.static(path.join(__dirname, 'images')));



const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        const dir = path.join(__dirname, 'images'); // Path to store the uploaded images
        fs.existsSync(dir) || fs.mkdirSync(dir);  // Ensure the directory exists
        cb(null, dir); // Set the destination folder
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname);
    }
});
const upload = multer({ storage });



app.post('/upload', upload.single('file'), (req, res) => {
    // Construct the full path relative to the images directory
    const imagesDir = path.join(__dirname, 'public', 'images');
    const relativePath = path.relative(imagesDir, req.file.path);
    const filePath = `/images/${relativePath.replace(/\\/g, '/')}`; // Ensure forward slashes for web

    const sql = 'INSERT INTO models (image_path) VALUES (?)';
    db.query(sql, [filePath], (err, result) => {
        if (err) throw err;
        res.json({ message: 'File uploaded!', path: filePath });
    });
});


app.get('/models', (req, res) => {
    db.query('SELECT * FROM models', (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

app.delete('/delete/:id', (req, res) => {
    const { id } = req.params;
    db.query('SELECT image_path FROM models WHERE id = ?', [id], (err, result) => {
        if (err) throw err;
        if (result.length > 0) {
            const filePath = path.join(__dirname, result[0].image_path);
            fs.unlink(filePath, (err) => {
                if (err) console.log('File not found or already deleted');
            });
        }
        db.query('DELETE FROM models WHERE id = ?', [id], (err, result) => {
            if (err) throw err;
            res.json({ message: 'Deleted successfully' });
        });
    });
});

app.post("/check-email-existence", async (req, res) => {
  const { email } = req.body;
  try {
    const exists = await checkEmailExistence(email);
    res.json({ exists });
  } catch (err) {
    res.status(500).json({ error: "Error checking email existence" });
  }
});

// Form submission endpoint
app.post("/submit-form", validateForm, async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  } else {
    const { name, email, password } = req.body;
    try {
      const results = await insertData(name, email, password);
      res.status(200).json({ success: true, message: 'Data inserted successfully', results });
    } catch (err) {
      res.status(500).json({ success: false, error: err });
    }
  }
});

app.get("/login", (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'login.html'));
});
app.get("/contact", (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'contact.html'));
});
app.get("/admin", (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'admin.html'));
});
app.get("/home", (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'testing.html'));
});
app.get("/profile", (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'profile.html'));
});
app.get("/3d", (req, res) => {
  res.sendFile(path.join(__dirname, 'public', '3D.html'));
});
app.get("/features", (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'features.html'));
});
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Set up MySQL connection
const db = mysql.createPool({
    host: 'localhost',       // MySQL host
    user: 'root',            // MySQL user
    password: '',            // MySQL password
    database: 'cardealership' // MySQL database name
});

// Check the connection pool
db.getConnection((err, connection) => {
    if (err) {
        console.error("Error connecting to the database pool:", err);
        if (connection) connection.release(); // Release connection if it was acquired but error occurred
        return;
    }
    console.log("Connected to the database pool.");
    connection.release(); // Release the connection back to the pool
});

// Endpoint to get all cars (using /best-deals as requested)
app.get('/best-deals', (req, res) => {
    db.query('SELECT * FROM cars ORDER BY RAND() LIMIT 5', (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        res.json(results);
    });
});

// Route to fetch all cars data
app.get('/cars', (req, res) => {
  db.query('SELECT * FROM cars', (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      return res.status(500).json({ error: 'Database query failed' });
    }
    res.json(results);
  });
});

// Helper function to handle search logging
const logSearch = async (req, results) => {
    if (req.session.user && results.length > 0) {
        const userId = req.session.user.id;
        try {
            for (const car of results) {
                await db.query('INSERT INTO search_log (user_id, car_id, search_timestamp) VALUES (?, ?, NOW())', [userId, car.id]);
            }
        } catch (logError) {
            console.error('Error logging search:', logError);
            // Decide how to handle logging errors
        }
    }
};
// Route to fetch and group cars by brand
app.get('/cars/grouped', (req, res) => {
    const query = `
        SELECT brand, COUNT(*) AS count FROM cars GROUP BY brand
    `;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        res.json(results);
    });
});
// Route to fetch cars by brand
app.get('/cars/:brand', (req, res) => {
    const brand = req.params.brand;
    const query = 'SELECT * FROM cars WHERE brand = ?';

    db.query(query, [brand], (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        res.json(results);
    });
});

// API Route to get cars by status
app.get('/cars/status/:status', (req, res) => {
    const { status } = req.params;
    
    const query = 'SELECT * FROM cars WHERE status = ? ORDER DESC';
    db.query(query, [status], (err, results) => {
        if (err) {
            console.error('Error fetching cars:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.json(results);
    });
});


// Route to fetch all cars data by brand
// Route to fetch all cars data by brand (supports partial search)
app.get('/brand/:brand', async (req, res) => {
    const brand = req.params.brand;

    // Check if user is logged in
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'User is not logged in' });
    }

    console.log("User is logged in: ID " + req.session.user.id + ", Name: " + req.session.user.name);

    // Using LIKE for partial search (matches brands starting with input)
    const query = 'SELECT * FROM cars WHERE brand LIKE ? ORDER BY brand ASC';
    const searchTerm = `${brand}%`; // Matches brands that start with the given letters

    db.query(query, [searchTerm], async (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        await logSearch(req, results);
        res.json(results);
    });
});


// Route to fetch all cars data by model
app.get('/model/:model', async (req, res) => {
    const model = req.params.model;

    // Check if user is logged in
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'User is not logged in' });
    }

    console.log("User is logged in: ID " + req.session.user.id + ", Name: " + req.session.user.name);

    // Using LIKE for partial search
    const query = 'SELECT * FROM cars WHERE model LIKE ? ORDER BY model ASC';
    const searchTerm = `${model}%`; // Matches models that start with the given letters

    db.query(query, [searchTerm], async (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        await logSearch(req, results);
        res.json(results);
    });
});


// Route to fetch all cars data by year
app.get('/year/:year', async (req, res) => {
    const year = parseInt(req.params.year, 10);

    // Check if user is logged in
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'User is not logged in' });
    }

    console.log("User is logged in: ID " + req.session.user.id + ", Name: " + req.session.user.name);

    if (isNaN(year)) {
        return res.status(400).json({ error: "Invalid year parameter" });
    }

    // Modify query to allow searching within a range (e.g., ±2 years)
    const query = `
        SELECT * FROM cars
        WHERE year BETWEEN ? AND ?
        ORDER BY ABS(year - ?), price ASC;
    `;

    db.query(query, [year - 2, year + 2, year], async (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        await logSearch(req, results);
        res.json(results);
    });
});


// Route to fetch all cars by price
app.get('/price/:price', async (req, res) => {
    const price = parseInt(req.params.price, 10);

    // Check if user is logged in
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'User is not logged in' });
    }

    console.log("User is logged in: ID " + req.session.user.id + ", Name: " + req.session.user.name);

    if (isNaN(price)) {
        return res.status(400).json({ error: "Invalid price parameter" });
    }

    // Query for exact price match
    const query = `
        SELECT * FROM cars
        WHERE price = ?
        ORDER BY price ASC;
    `;

    db.query(query, [price], async (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        await logSearch(req, results);
        res.json(results);
    });
});


// Route to fetch all cars by mileage
app.get('/mileage/:mileage', async (req, res) => {
    const mileage = parseInt(req.params.mileage, 10);

    // Check if user is logged in
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'User is not logged in' });
    }

    console.log("User is logged in: ID " + req.session.user.id + ", Name: " + req.session.user.name);

    if (isNaN(mileage)) {
        return res.status(400).json({ error: "Invalid mileage parameter" });
    }

    // Query for exact mileage match
    const query = `
        SELECT * FROM cars
        WHERE mileage = ?
        ORDER BY mileage ASC;
    `;

    db.query(query, [mileage], async (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        await logSearch(req, results);
        res.json(results);
    });
});


// Route to fetch all cars by fuel type
app.get('/fuel/:fuel_type', async (req, res) => {
    const fuel_type = req.params.fuel_type;
    
    // Check if user is logged in
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'User is not logged in' });
    }

    console.log("User is logged in: ID " + req.session.user.id + ", Name: " + req.session.user.name);

    // Extract user details from session
    const userId = req.session.user.id; // Assuming you have user authentication

    const query = 'SELECT * FROM cars WHERE fuel_type = ?';

    db.query(query, [fuel_type], async (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }

        if (userId && results.length > 0) {
            try {
                for (const car of results) {
                    await db.query('INSERT INTO search_log (user_id, car_id, search_timestamp) VALUES (?, ?, NOW())', [userId, car.id]);
                }
            } catch (logError) {
                console.error('Error logging search:', logError);
                // It's important to decide how to handle logging errors.
                // You might want to log it but still send the car results.
                // Or, in a critical system, you might want to return an error.
            }
        }
        res.json(results);
    });
});

// Route to fetch all cars by transmission
app.get('/transmission/:transmission', async (req, res) => {
    const transmission = req.params.transmission;
    // Check if user is logged in
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'User is not logged in' });
    }

    console.log("User is logged in: ID " + req.session.user.id + ", Name: " + req.session.user.name);

    // Extract user details from session
    const userId = req.session.user.id; // Assuming you have user authentication
   

    const query = 'SELECT * FROM cars WHERE transmission = ? ORDER BY price ASC';

    db.query(query, [transmission], async (err, results) => {
        if (err) {
            console.error('Database query error:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }

        if (userId && results.length > 0) {
            try {
                for (const car of results) {
                    await db.query('INSERT INTO search_log (user_id, car_id, search_timestamp) VALUES (?, ?, NOW())', [userId, car.id]);
                }
            } catch (logError) {
                console.error('Error logging search:', logError);
                // Handle logging error (as discussed in the fuel type route)
            }
        }
        res.json(results);
    });
});

// Route to fetch all cars
app.get('/all/', (req, res) => {
  const query = 'SELECT * FROM cars';

  db.query(query, (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      return res.status(500).json({ error: 'Database query failed' });
    }
    res.json(results);
  });
});

// Route to fetch all cars by multiple criteria
app.get('/all', (req, res) => {
  const model = ['corolla', 'civic', 'c-class', 'malibu', 'optima', 'impreza', 'Elantra', 'A4'];
  const transmission = 'manual';
  const year = ['2019', '2020', '2021', '2022', '2023'];
  const fuel_type = 'Petrol';
  const brand = ['toyota', 'honda', 'ford', 'Nissan', 'Tesla', 'subaru', 'Audi', 'Kia'];
  const mileage= 20000;
  const price = 25000;

  const Maxrange = price + 10000;
  const Minrange = price - 10000;
  const pMaxrange = mileage + 1000;
  const pMinrange = mileage - 1000;

  const query = `
    SELECT * FROM cars 
    WHERE transmission = ? 
    AND model IN (?) 
    AND year IN (?) 
    AND fuel_type = ? 
    AND brand IN (?) 
    AND mileage BETWEEN ? AND ? 
    AND price BETWEEN ? AND ?`;

  db.query(query, [transmission, model, year, fuel_type, brand, pMinrange, pMaxrange, Minrange, Maxrange], (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      return res.status(500).json({ error: 'Database query failed' });
    }
    res.json(results);
  });
});



app.post('/addCar', upload.array('images', 5), (req, res) => {
    const { brand, model, year, price, mileage, fuel_type, transmission, color, carId } = req.body;
    const images = req.files.map(file => path.join('images', carId, file.filename));

    const sql = 'INSERT INTO cars (brand, model, year, price, mileage, fuel_type, transmission, color, image_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
    const values = [brand, model, year, price, mileage, fuel_type, transmission, color, JSON.stringify(images)];

    db.query(sql, values, (err, result) => {
        if (err) throw err;
        io.emit('carAdded', { id: result.insertId, brand, model, year, price, mileage, fuel_type, transmission, color, images });
        res.send('Car details uploaded successfully');
    });
});
// ✅ Route to update car details (using callbacks)
app.post('/updateCar/:id', (req, res) => {
    const { id } = req.params;
    const { field, value } = req.body;

    // ✅ Debugging: Log incoming request data
    console.log("Received Update Request:", { id, field, value });

    // ✅ Ensure 'field' is a valid column name to prevent SQL Injection
    const allowedFields = ['brand', 'model', 'year', 'price']; 
    if (!allowedFields.includes(field)) {
        return res.status(400).json({ success: false, message: "Invalid field name" });
    }

    // ✅ Use parameterized query
    db.query(`UPDATE cars SET \`${field}\` = ? WHERE id = ?`, [value, id], (error, result) => {
        if (error) {
            console.error("Error updating car:", error);
            return res.status(500).json({ success: false, message: "Server error: " + error.message });
        }

        console.log("SQL Update Result:", result);

        if (result.affectedRows > 0) {
            res.json({ success: true, message: `Updated ${field} successfully.` });
        } else {
            res.json({ success: false, message: "No rows updated. Check if ID is correct." });
        }
    });
});



// Endpoint to get all cars
app.get('/getCars', (req, res) => {
    db.query('SELECT * FROM cars', (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Endpoint to delete a car by ID
app.delete('/deleteCar/:id', (req, res) => {
    const carId = req.params.id;
    db.query('DELETE FROM cars WHERE id = ?', [carId], (err, result) => {
        if (err) throw err;
        io.emit('carDeleted', carId);  // Notify clients in real-time
        res.send('Car deleted successfully');
    });
});

// Endpoint to update a car
app.put('/updateCar/:id', (req, res) => {
    const carId = req.params.id;
    const { brand, model, year, price, mileage, fuel_type, transmission, color } = req.body;

    const sql = 'UPDATE cars SET brand = ?, model = ?, year = ?, price = ?, mileage = ?, fuel_type = ?, transmission = ?, color = ? WHERE id = ?';
    const values = [brand, model, year, price, mileage, fuel_type, transmission, color, carId];

    db.query(sql, values, (err, result) => {
        if (err) throw err;
        io.emit('carUpdated', { id: carId, brand, model, year, price, mileage, fuel_type, transmission, color });
        res.send('Car details updated successfully');
    });
});



// Handle the order submission
app.post('/submit_order', (req, res) => {
    const { brand, model, year, price, imagePath, color, paymentMethod ,customize} = req.body;

    // Check if user is logged in
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'User is not logged in' });
    }

    console.log("User is logged in: ID " + req.session.user.id + ", Name: " + req.session.user.name);

    // Extract user details from session
    const owner_id = req.session.user.id;
    const owner_name = req.session.user.name;

    // Validate request body
    if (!brand || !model || !year || !price || !color ||!imagePath ||  !paymentMethod || !customize) {
        return res.status(400).json({ success: false, message: 'Missing required fields' });
    }

    // SQL query to insert the order into the database
    const query = 'INSERT INTO orders (owner_id, owner_name, brand, model, year, price,carImage_path, color, payment_method,customization) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?)';
    const values = [owner_id, owner_name, brand, model, year, price,imagePath, color, paymentMethod,customize];

    db.execute(query, values, (err, results) => {
        if (err) {
            console.error('Error inserting order:', err);
            return res.status(500).json({ success: false, message: 'Failed to place order' });
        }
        res.json({ success: true, message: 'Order placed successfully' });
    });
});

// ✅ Route: Get all orders
app.get("/admin/orders", (req, res) => {
    const sql = "SELECT * FROM orders";
    db.query(sql, (error, results) => {
        if (error) {
            console.error("Error fetching orders:", error);
            return res.status(500).json({ success: false, message: "Server error" });
        }
        res.json({ success: true, orders: results });
    });
});

// ✅ Route: Update order status
app.put("/admin/orders/:id", (req, res) => {
    const { id } = req.params;
    const { status } = req.body;

    const sql = "UPDATE orders SET status = ? WHERE id = ?";
    db.query(sql, [status, id], (error, result) => {
        if (error) {
            console.error("Error updating order:", error);
            return res.status(500).json({ success: false, message: "Server error" });
        }
        if (result.affectedRows > 0) {
            res.json({ success: true, message: "Order updated successfully" });
        } else {
            res.json({ success: false, message: "Order not found" });
        }
    });
});

// ✅ Route: Delete an order
app.delete("/admin/orders/:id", (req, res) => {
    const { id } = req.params;

    const sql = "DELETE FROM orders WHERE id = ?";
    db.query(sql, [id], (error, result) => {
        if (error) {
            console.error("Error deleting order:", error);
            return res.status(500).json({ success: false, message: "Server error" });
        }
        if (result.affectedRows > 0) {
            res.json({ success: true, message: "Order deleted successfully" });
        } else {
            res.json({ success: false, message: "Order not found" });
        }
    });
});

// Endpoint to get user orders with order_status
app.get('/orders', (req, res) => {
    // Check if the user is authenticated
    if (!req.session.user || !req.session.user.id) {
        return res.status(401).json({ error: 'User not authenticated' });
    }

    const userId = req.session.user.id;

    // Proper SQL query string (wrap inside quotes)
    const query = `
        SELECT * FROM orders 
        WHERE owner_id = ?
    `;

    // Use mysql2 style with callback
    db.execute(query, [userId], (err, results) => {
        if (err) {
            console.error('Error fetching user orders:', err);
            return res.status(500).json({ error: 'Failed to fetch orders' });
        }

        return res.json(results);
    });
});


// Endpoint to get orders by status (active/deleted)
app.get('/orders/status', (req, res) => {
    const userId = req.session.user.id;
    const status = req.query.status;  // Get status from query parameters, e.g., ?status=active

    if (!userId) {
        return res.status(401).json({ error: 'User not authenticated' });
    }

    if (!status || (status !== 'active' && status !== 'deleted')) {
        return res.status(400).json({ error: 'Invalid status. Status must be either "active" or "deleted"' });
    }

    // SQL query to fetch orders based on their status
    const query = `
        SELECT order_id, brand, model, YEAR, order_date, payment_method, price, 
               amount_paid, balance, payment_status, order_status 
        FROM orders 
        WHERE owner_id = ? AND order_status = ?
    `;

    db.execute(query, [userId, status], (err, results) => {
        if (err) {
            console.error('Error fetching orders by status:', err);
            return res.status(500).json({ error: 'Failed to fetch orders' });
        }
        res.json(results);
    });
});


// Handle fetching all orders
app.get('/view_orders', (req, res) => {
    // Retrieve userId from the session
    const userId = req.session.user ? req.session.user.id : null;


    // If user is not logged in, return an error
    if (!userId) {
        return res.status(401).json({ success: false, message: 'You must be logged in to view your orders' });
    }

    // Query to fetch orders only for the logged-in user
    const query = 'SELECT * FROM orders WHERE owner_id = ? ORDER BY order_date DESC';

    db.execute(query, [userId], (err, results) => {
        if (err) {
            console.error('Error fetching orders:', err);
            return res.status(500).json({ success: false, message: 'Failed to fetch orders' });
        }

        // Send back the orders for the logged-in user
        res.json(results);
    });
});
// Fetch all payments
app.get("/api/payments", (req, res) => {
    const query = "SELECT id, name, location, amount_paid, date_paid, payment_status FROM payments";
    db.query(query, (err, results) => {
        if (err) {
            console.error("Error fetching payments:", err);
            return res.status(500).json({ success: false, message: "Database error" });
        }
        res.json(results);
    });
});
// Update payment status
app.post("/api/update-payment-status/:id", (req, res) => {
    const { id } = req.params;
    const { status } = req.body;

    if (!status) {
        return res.status(400).json({ success: false, message: "Status is required" });
    }

    const updateQuery = "UPDATE payments SET payment_status = ? WHERE id = ?";
    db.query(updateQuery, [status, id], (err, result) => {
        if (err) {
            console.error("Error updating payment status:", err);
            return res.status(500).json({ success: false, message: "Database error" });
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: "Payment not found" });
        }

        res.json({ success: true, updatedPayment: { id, payment_status: status } });
    });
});


app.post('/submit_payment', (req, res) => {
    // Extract data from the request body
    const { order_id, payment_method, amount, location, name, phone, costamount } = req.body;
// Check if user is logged in
    if (!req.session.user) {
        return res.status(401).json({ success: false, message: 'User is not logged in' });
    }

    console.log("User is logged in: ID " + req.session.user.id + ", Name: " + req.session.user.name);

    // Extract user details from session
    const owner_id = req.session.user.id;
    
 
    // Make sure all necessary data is provided
    if (!order_id || !payment_method || !amount || !location || !name || !phone || !costamount ) {
        return res.status(400).json({ error: 'All fields are required.' });
    }

    // Initialize amount_paid as the amount entered by the user
    const amount_paid = amount;
    const car_cost = costamount; // Cost of the car
    const balance = car_cost - amount_paid; // Calculate balance

    // Insert payment data into the database
    const query = `INSERT INTO payments (order_id,owner_id, payment_method, Car_cost, location, name, phone, payment_status, date_paid, balance, amount_paid) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, 'Pending', NOW(), ?, ?)`; // 'Pending' status initially

    db.query(query, [order_id,owner_id,payment_method, car_cost, location, name, phone, balance, amount_paid], (err, results) => {
        if (err) {
            console.error('Error submitting payment:', err);
            return res.status(500).json({ error: 'An error occurred while submitting payment.' });
        }

        // Send success response
        res.json({ success: true, message: 'Payment submitted successfully.' });
    });
});

// API endpoint to view payment details for the logged-in owner
app.get('/view_payments', (req, res) => {
    // Check if the user is logged in and has a session ID
    if (!req.session.user) {
        return res.status(401).json({ error: 'User not logged in' });
    }

    const ownerId = req.session.user.id; // Get the owner ID from the session

    const sql = 'SELECT * FROM payments WHERE owner_id = ?';
    db.query(sql, [ownerId], (err, results) => {
        if (err) {
            console.error('Error fetching payment details:', err);
            res.status(500).json({ error: 'Failed to fetch payment details' });
            return;
        }
        res.json(results);
    });
});

app.post('/register', async (req, res) => {
    console.log("Register Request Body:", req.body); // Log the entire request body
    const { username, email, password, address } = req.body;

    console.log("Username:", username);
    console.log("Email:", email);
    console.log("Password:", password);
    console.log("Address:", address);

    // Ensure all fields are provided
    if (!username || !email || !password || !address) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insert user into the database
    const sqlInsert = "INSERT INTO users (name, email, password, hashedpassword, address) VALUES (?, ?, ?, ?, ?)";
    db.query(sqlInsert, [username, email, password, hashedPassword, address], (errInsert, resultInsert) => {
        if (errInsert) {
            console.error('Error inserting user:', errInsert);
            return res.status(500).json({ error: 'Database error during registration', details: errInsert });
        }

        // Get the ID of the newly inserted user
        const userId = resultInsert.insertId;

        // Fetch the newly registered user's details
        const sqlSelect = "SELECT id, name, email FROM users WHERE id = ?";
        db.query(sqlSelect, [userId], (errSelect, resultsSelect) => {
            if (errSelect) {
                console.error('Error fetching user after registration:', errSelect);
                return res.status(500).json({ error: 'Database error fetching user', details: errSelect });
            }

            if (resultsSelect.length > 0) {
                const newUser = resultsSelect[0];
                // Store user session with the fetched user details
                req.session.user = { id: newUser.id, name: newUser.name, email: newUser.email };
                req.session.type = 'register';

                // Send success response
                res.json({ message: 'User registered successfully', redirect: '/profile' });
            } else {
                console.error('Could not find user after registration with ID:', userId);
                return res.status(500).json({ error: 'Error retrieving user after registration' });
            }
        });
    });
});
//admin fetch customers
app.get('/customers', (req, res) => {
    db.query('SELECT * FROM users', (err, results) => {
        if (err) {
            res.status(500).json({ error: err.message });
        } else {
            res.json(results);
        }
    });
});
//update customers
app.post('/update-customer', (req, res) => {
    const { id, field, value } = req.body;
    db.query(`UPDATE users SET ?? = ? WHERE id = ?`, [field, value, id], (err) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ success: true });
    });
});
//get the totals

app.get('/dashboard-data', (req, res) => {
    const queries = {
        totalCars: 'SELECT COUNT(*) AS count FROM cars',
        totalCustomers: 'SELECT COUNT(*) AS count FROM users',
        totalSales: 'SELECT COUNT(*) AS count FROM payments'
    };

    db.query(queries.totalCars, (err, carsResult) => {
        if (err) return res.status(500).json({ error: err.message });
        db.query(queries.totalCustomers, (err, customersResult) => {
            if (err) return res.status(500).json({ error: err.message });
            db.query(queries.totalSales, (err, salesResult) => {
                if (err) return res.status(500).json({ error: err.message });
                res.json({
                    totalCars: carsResult[0].count,
                    totalCustomers: customersResult[0].count,
                    totalSales: salesResult[0].count
                });
            });
        });
    });
});

app.post('/login', (req, res) => {
    const { email, password } = req.body;

    // Validate if email and password are provided
    if (!email || !password) {
        return res.status(400).json({ error: 'Email and password are required' });
    }

    const sql = "SELECT * FROM users WHERE email = ?";
    
    db.query(sql, [email], async (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Database error' });
        }
        
        // If no user found
        if (results.length === 0) {
            return res.status(400).json({ error: 'Invalid email or password' });
        }

        const user = results[0];

        // Compare the provided password with the stored hashed password
        const isMatch = await bcrypt.compare(password, user.hashedpassword);

        if (!isMatch) {
            return res.status(400).json({ error: 'Invalid email or password' });
        }

        // Store user session
        req.session.user = { id: user.id, name: user.name, email: user.email };
        req.session.type = 'login'; 

        // Send success message and user info
        res.json({ message: 'Login successful', user: req.session.user });
    });
});


app.get('/logout', (req, res) => {
    req.session.destroy(() => {
        res.json({ message: 'Logged out successfully' });
    });
});

app.get("/user", (req, res) => {
    // Check if the session user exists
    console.log("Session User: ", req.session.user);  // Debugging log
    
    if (!req.session.user) {
        return res.status(401).json({ error: "User not logged in or registered" });
    }

    // Check if the session is for login or registration
    const sessionType = req.session.type || 'login'; // Default to 'login' if type is not set
    console.log("Session Type: ", sessionType);  // Debugging log

    if (sessionType !== 'login' && sessionType !== 'register') {
        return res.status(400).json({ error: "Invalid session type" });
    }

    const query = "SELECT * FROM users WHERE id = ?";
    
    db.query(query, [req.session.user.id], (err, results) => {
        if (err) {
            console.error("Database error: ", err);  // Debugging log
            return res.status(500).json({ error: err.message });
        }
        if (results.length === 0) {
            console.log("User not found in database");  // Debugging log
            return res.status(404).json({ error: "User not found" });
        }

        res.json(results[0]);
    });
});


// Server-side JavaScript (Node.js with Express)

// API endpoint to fetch recommended cars (based on search history)
app.get('/api/recommended_cars', async (req, res) => {
    if (!req.session.user) {
        return res.status(401).json({ error: 'User not logged in' });
    }

    const userId = req.session.user.id;

    try {
        // 1. Get the recently searched car IDs for the current user
        const searchLogQuery = `
            SELECT DISTINCT sl.car_id
            FROM search_log sl
            WHERE sl.user_id = ?
            ORDER BY sl.search_timestamp DESC
            LIMIT 5; -- Limit to the last 5 unique searches
        `;
        const [searchLogResults] = await db.promise().query(searchLogQuery, [userId]);
        const searchedCarIds = searchLogResults.map(row => row.car_id);

        if (searchedCarIds.length === 0) {
            return res.json([]); // No recent searches
        }

        // 2. Fetch the details of these cars along with their images
        const carsQuery = `
            SELECT c.*
            FROM cars c
            WHERE c.id IN (?)
        `;
        const [carsResults] = await db.promise().query(carsQuery, [searchedCarIds]);

        res.json(carsResults);

    } catch (error) {
        console.error('Error fetching recommended cars:', error);
        res.status(500).json({ error: 'Failed to fetch recommended cars' });
    }
});
// Routes
app.post('/api/contact', (req, res) => {
  const { name, email, subject, message } = req.body;
  const query = 'INSERT INTO contact_messages (name, email, subject, message) VALUES (?, ?, ?, ?)';
  db.query(query, [name, email, subject, message], (err, result) => {
    if (err) {
      console.error('❌ Error inserting message:', err);
      res.status(500).send('Error saving message.');
    } else {
      res.status(200).send('Message received!');
    }
  });
});
app.get('/sales-summary', (req, res) => {
    const queries = {
        totalSales: 'SELECT COUNT(*) AS count FROM payments',
        totalRevenue: 'SELECT SUM(amount_paid) AS revenue FROM payments',
        totalProfit: 'SELECT SUM(amount_paid * 0.2) AS profit FROM payments', // Assuming 20% profit margin
        completedTransactions: "SELECT COUNT(*) AS count FROM payments WHERE payment_status = 'Completed'",
        pendingTransactions: "SELECT COUNT(*) AS count FROM payments WHERE payment_status = 'Pending'",
        cancelledTransactions: "SELECT COUNT(*) AS count FROM payments WHERE payment_status = 'Cancelled'"
    };

    // Step 1: Get total sales count
    db.query(queries.totalSales, (err, salesResult) => {
        if (err) return res.status(500).json({ error: err.message });

        // Step 2: Get total revenue
        db.query(queries.totalRevenue, (err, revenueResult) => {
            if (err) return res.status(500).json({ error: err.message });

            // Step 3: Get total profit
            db.query(queries.totalProfit, (err, profitResult) => {
                if (err) return res.status(500).json({ error: err.message });

                // Step 4: Get completed transactions count
                db.query(queries.completedTransactions, (err, completedResult) => {
                    if (err) return res.status(500).json({ error: err.message });

                    // Step 5: Get pending transactions count
                    db.query(queries.pendingTransactions, (err, pendingResult) => {
                        if (err) return res.status(500).json({ error: err.message });

                        // Step 6: Get cancelled transactions count
                        db.query(queries.cancelledTransactions, (err, cancelledResult) => {
                            if (err) return res.status(500).json({ error: err.message });

                            // Step 7: Send the response
                            res.json({
                                totalSales: salesResult[0].count,
                                totalRevenue: revenueResult[0].revenue || 0,
                                totalProfit: profitResult[0].profit || 0,
                                completedTransactions: completedResult[0].count,
                                pendingTransactions: pendingResult[0].count,
                                cancelledTransactions: cancelledResult[0].count
                            });
                        });
                    });
                });
            });
        });
    });
});
//getting reports
app.get('/api/reports', (req, res) => {
    let statusFilter = req.query.status;
    let query = 'SELECT id, name AS customer, amount_paid AS amount, payment_method AS method, payment_status AS status, date_paid AS date FROM payments';

    if (statusFilter && statusFilter !== 'all') {
        query += ` WHERE payment_status = '${statusFilter}'`;
    }

    db.query(query, (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json(results);
    });
});
app.get('/api/admin-info', (req, res) => {
    const adminId = req.session.adminId; // Assume admin is logged in via session

    if (!adminId) {
        return res.status(401).json({ error: "Not logged in" });
    }

    db.query("SELECT name, avatar FROM admins WHERE id = ?", [adminId], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        if (result.length === 0) {
            return res.status(404).json({ error: "Admin not found" });
        }
        res.json(result[0]);
    });
});

async function hashExistingPasswords() {
  try {
    db.query("SELECT id, password FROM admins", async (err, results) => {
      if (err) {
        console.error("Error fetching admins:", err);
        return;
      }

      for (const admin of results) {
        const plainTextPassword = admin.password;
        const hashedPassword = await bcrypt.hash(plainTextPassword, 10);

        db.query(
          "UPDATE admins SET password = ? WHERE id = ?",
          [hashedPassword, admin.id],
          (updateErr, updateResult) => {
            if (updateErr) {
              console.error(`Error updating admin ${admin.id}:`, updateErr);
            } else {
              console.log(`Password for admin ${admin.id} updated.`);
            }
          }
        );
      }
      console.log("Password hashing process completed.");
      // db.end(); // If you're running this as a standalone script
    });
  } catch (error) {
    console.error("Error during password hashing:", error);
  }
}


// Login Route
app.post("/api/admin/login", (req, res) => {
    const { email, password } = req.body;
    
    
    db.query("SELECT * FROM admins WHERE email = ?", [email], async (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.length === 0) return res.status(401).json({ error: "Invalid email or password" });

        const admin = result[0];
        const isMatch = await bcrypt.compare(password, admin.password);
        if (!isMatch) return res.status(401).json({ error: "Invalid email or password" });

        // Save session
        req.session.adminId = admin.id;

        res.json({
            message: "Login successful",
            admin: { id: admin.id, name: admin.name, avatar: admin.avatar }
        });
    });
});

// Logout Route
app.post("/api/admin/logout", (req, res) => {
    req.session.destroy();
    res.json({ message: "Logged out successfully" });
});
// API Endpoint to Fetch Cars with 3D Model Paths
app.get('/api/cars-with-models', (req, res) => {
    const sql = `
        SELECT
            c.id,
            c.brand,
            c.price,
            c.model,
            c.year,
            c.fuel_type,
            c.mileage,
            c.color,
            c.transmission,
            c.image_path,
            m.image_path AS model_path
        FROM
            cars c
        INNER JOIN
            models m ON c.id = m.id;
    `;

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching cars with models:', err);
            return res.status(500).json({ error: 'Failed to fetch data.' });
        }
        res.json(results);
    });
});
// API endpoint to delete an order
app.get('/delete_order/:id', (req, res) => {
    const orderId = req.params.id;
    
    const sql = "UPDATE orders SET order_status = 'deleted' WHERE id = ?"; // Adjust table name and id column if needed
    db.query(sql, [orderId], (err, result) => {
        if (err) {
            console.error('Error deleting order:', err);
            res.status(500).json({ error: 'Failed to delete order.' });
            return;
        }
        if (result.affectedRows > 0) {
            res.json({ message: 'Order deleted successfully.' });
        } else {
            res.status(404).json({ message: 'Order not found.' });
        }
    });
});

server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
