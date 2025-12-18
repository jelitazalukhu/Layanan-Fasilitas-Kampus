const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

exports.register = async (req, res) => {
    try {
        const { email, nim, password, name } = req.body;

        // Check if user exists
        const existingUser = await prisma.user.findFirst({
            where: {
                OR: [
                    { email },
                    { nim }
                ]
            },
        });

        if (existingUser) {
            return res.status(400).json({ message: 'User with this Email or NIM already exists' });
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create user
        const user = await prisma.user.create({
            data: {
                email,
                nim,
                password: hashedPassword,
                name,
            },
        });

        // Create token
        const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, {
            expiresIn: '1h',
        });

        res.status(201).json({ token, user: { id: user.id, email: user.email, nim: user.nim, name: user.name } });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

exports.login = async (req, res) => {
    try {
        const { nim, password } = req.body;

        // Check if user exists
        const user = await prisma.user.findUnique({
            where: { nim },
        });

        if (!user) {
            return res.status(400).json({ message: 'Invalid credentials' });
        }

        // Check password
        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid credentials' });
        }

        // Create token
        const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, {
            expiresIn: '1h',
        });

        res.status(200).json({ token, user: { id: user.id, email: user.email, nim: user.nim, name: user.name } });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

exports.getProfile = async (req, res) => {
    try {
        const user = await prisma.user.findUnique({
            where: { id: req.user.userId },
            where: { id: req.user.userId },
            select: { id: true, name: true, email: true, nim: true, avatarUrl: true } // Exclude password
        });
        if (!user) return res.status(404).json({ message: 'User not found' });
        res.json(user);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};

exports.updateProfile = async (req, res) => {
    try {
        const userId = req.user.userId;
        const { name, password } = req.body;

        const data = {};
        if (name) data.name = name;
        if (password) {
            data.password = await bcrypt.hash(password, 10);
        }
        if (req.file) {
            // Save relative path
            data.avatarUrl = '/uploads/' + req.file.filename;
        }

        const user = await prisma.user.update({
            where: { id: userId },
            data,
            select: { id: true, name: true, email: true, nim: true, avatarUrl: true }
        });

        res.json({ message: 'Profile updated', user });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error' });
    }
};
