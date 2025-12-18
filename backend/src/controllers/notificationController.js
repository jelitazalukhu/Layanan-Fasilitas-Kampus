const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.getNotifications = async (req, res) => {
    try {
        const userId = req.user.userId;
        const notifications = await prisma.notification.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' }
        });
        res.json(notifications);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

exports.markAsRead = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.user.userId;

        // Verify ownership
        const notification = await prisma.notification.findUnique({ where: { id: parseInt(id) } });
        if (!notification || notification.userId !== userId) {
            return res.status(404).json({ message: 'Notification not found' });
        }

        await prisma.notification.update({
            where: { id: parseInt(id) },
            data: { isRead: true }
        });

        res.json({ success: true });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

// Internal helper or seed endpoint to create dummy notification
exports.seedNotification = async (req, res) => {
    try {
        const userId = req.user.userId;
        await prisma.notification.createMany({
            data: [
                { userId, title: 'Booking Berhasil', message: 'Booking Auditorium Anda telah dikonfirmasi.' },
                { userId, title: 'Jadwal Maintenance', message: 'Sistem akan maintenance pada tanggal 20.' },
                { userId, title: 'Selamat Datang!', message: 'Selamat datang di CampusFind.' },
            ]
        });
        res.json({ message: 'Notifications seeded' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};
