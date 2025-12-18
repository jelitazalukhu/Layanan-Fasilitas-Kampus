const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Get all facilities
exports.getAllFacilities = async (req, res) => {
    try {
        const { search } = req.query;
        const where = search ? {
            OR: [
                { name: { contains: search } },
                { location: { contains: search } },
                { category: { contains: search } },
            ]
        } : {};

        const facilities = await prisma.facility.findMany({ where });
        res.json(facilities);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

// Create a booking
exports.createBooking = async (req, res) => {
    try {
        const { facilityId, date, startTime, endTime } = req.body;
        const userId = req.user.userId; // From authMiddleware

        // Basic validation
        if (startTime >= endTime) {
            return res.status(400).json({ message: 'Start time must be before end time' });
        }

        // Check if facility is open
        const facility = await prisma.facility.findUnique({ where: { id: facilityId } });
        if (!facility) {
            return res.status(404).json({ message: 'Facility not found' });
        }

        if (startTime < facility.openHour || endTime > facility.closeHour) {
            return res.status(400).json({
                message: `Facility is only open from ${facility.openHour}:00 to ${facility.closeHour}:00`
            });
        }

        // Check availability (simplistic overlap check)
        // Parse date to start of day for comparison if needed, or assume ISO string
        const bookingDate = new Date(date);

        const conflicts = await prisma.booking.findMany({
            where: {
                facilityId: parseInt(facilityId),
                date: bookingDate,
                status: { not: 'REJECTED' },
                OR: [
                    {
                        AND: [
                            { startTime: { lte: startTime } },
                            { endTime: { gt: startTime } },
                        ],
                    },
                    {
                        AND: [
                            { startTime: { lt: endTime } },
                            { endTime: { gte: endTime } },
                        ],
                    },
                ],
            },
        });

        if (conflicts.length > 0) {
            return res.status(400).json({ message: 'Facility is already booked for this time slot' });
        }

        const booking = await prisma.booking.create({
            data: {
                userId,
                facilityId: parseInt(facilityId),
                date: bookingDate,
                startTime,
                endTime,
                status: 'CONFIRMED', // Auto confirm for now
            },
        });

        // Create notification
        await prisma.notification.create({
            data: {
                userId,
                title: 'Booking Berhasil!',
                message: `Booking ${facility.name} pada tanggal ${date} jam ${startTime}:00 - ${endTime}:00 berhasil.`,
            }
        });

        res.status(201).json(booking);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

// Seed initial data
exports.seedFacilities = async (req, res) => {
    try {
        const count = await prisma.facility.count();
        if (count > 0) {
            return res.json({ message: 'Facilities already seeded' });
        }

        const facilities = [
            {
                name: "Perpustakaan",
                location: "Kampus USU",
                imageUrl: "assets/perpustakaan.jpeg",
                category: "Fasilitas Umum",
                openHour: 8,
                closeHour: 17,
                description: "Perpustakaan pusat dengan fasilitas WiFi dan AC",
            },
            {
                name: "Auditorium",
                location: "Kampus USU",
                imageUrl: "assets/auditorium.webp",
                category: "Fasilitas Umum",
                openHour: 8,
                closeHour: 22,
                description: "Gedung serbaguna untuk acara besar",
            },
            {
                name: "Poliklinik",
                location: "Kampus USU",
                imageUrl: "assets/poli.jpg",
                category: "Fasilitas Umum",
                openHour: 8,
                closeHour: 16,
                description: "Layanan kesehatan untuk mahasiswa",
            },
            {
                name: "Masjid Kampus",
                location: "Kampus USU",
                imageUrl: "assets/masjid_ar-rahman.jpg",
                category: "Masjid",
                openHour: 4,
                closeHour: 22,
                description: "Tempat ibadah utama",
            }
        ];

        for (const f of facilities) {
            await prisma.facility.create({ data: f });
        }

        res.json({ message: 'Facilities seeded successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};
