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
        const { facilityId, date, startTime, endTime, roomName } = req.body;
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

        // Check availability
        const bookingDate = new Date(date);

        // Build conflict query
        let conflictWhere = {
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
        };

        if (roomName) {
            conflictWhere.roomName = roomName;
        }

        const conflicts = await prisma.booking.findMany({ where: conflictWhere });

        if (conflicts.length > 0) {
            return res.status(400).json({ message: 'Slot is already booked' });
        }

        const booking = await prisma.booking.create({
            data: {
                userId,
                facilityId: parseInt(facilityId),
                date: bookingDate,
                startTime,
                endTime,
                roomName,
                status: 'CONFIRMED', // Auto confirm for now
            },
        });

        // Create notification
        const specificPlace = roomName ? `${facility.name} - ${roomName}` : facility.name;
        await prisma.notification.create({
            data: {
                userId,
                title: 'Booking Berhasil!',
                message: `Booking ${specificPlace} pada tanggal ${date.split('T')[0]} jam ${startTime}:00 - ${endTime}:00 berhasil.`,
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
            },
            // NEW FACULTIES
            {
                name: "Fakultas FMIPA",
                location: "Kampus USU",
                imageUrl: "assets/fakultas.jpg",
                category: "Fakultas",
                openHour: 8,
                closeHour: 17,
                description: "Fakultas Matematika dan Ilmu Pengetahuan Alam",
            },
            {
                name: "Fakultas Vokasi",
                location: "Kampus USU",
                imageUrl: "assets/fakultas.jpg",
                category: "Fakultas",
                openHour: 8,
                closeHour: 17,
                description: "Fakultas Vokasi",
            },
            {
                name: "Fakultas Keperawatan",
                location: "Kampus USU",
                imageUrl: "assets/keperawatan.jpg",
                category: "Fakultas",
                openHour: 8,
                closeHour: 17,
                description: "Fakultas Keperawatan",
            },
            {
                name: "Fakultas Ilmu Budaya",
                location: "Kampus USU",
                imageUrl: "assets/fakultas-ilmu-budaya.webp",
                category: "Fakultas",
                openHour: 8,
                closeHour: 17,
                description: "Fakultas Ilmu Budaya (Sastra)",
            },
            {
                name: "Fakultas Psikologi",
                location: "Kampus USU",
                imageUrl: "assets/psikologi.jpg",
                category: "Fakultas",
                openHour: 8,
                closeHour: 17,
                description: "Fakultas Psikologi",
            }
        ];

        let addedCount = 0;
        let updatedCount = 0;
        for (const f of facilities) {
            const exists = await prisma.facility.findFirst({ where: { name: f.name } });
            if (!exists) {
                await prisma.facility.create({ data: f });
                addedCount++;
            } else if (f.name === "Fakultas FMIPA" || f.name === "Fakultas Psikologi" || f.name === "Fakultas Keperawatan") {
                await prisma.facility.update({
                    where: { id: exists.id },
                    data: { imageUrl: f.imageUrl }
                });
                updatedCount++;
            }
        }

        res.json({ message: `Facilities seeding complete. Added ${addedCount}, Updated ${updatedCount}.` });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};
