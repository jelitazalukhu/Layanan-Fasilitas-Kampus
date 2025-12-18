const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const authRoutes = require('./routes/authRoutes');

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

const facilityRoutes = require('./routes/facilityRoutes');
const notificationRoutes = require('./routes/notificationRoutes');

// Routes
app.use('/api/auth', authRoutes);
app.use('/api', facilityRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/uploads', express.static('uploads'));

// Basic health check
app.get('/', (req, res) => {
  res.send('Layanan Fasilitas Kampus Backend is running');
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
