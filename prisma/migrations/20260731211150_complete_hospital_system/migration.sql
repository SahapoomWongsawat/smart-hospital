/*
  Warnings:

  - You are about to drop the column `date` on the `Appointment` table. All the data in the column will be lost.
  - You are about to drop the column `department` on the `Doctor` table. All the data in the column will be lost.
  - You are about to drop the column `number` on the `Queue` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[lineUserId]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `appointmentDate` to the `Appointment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `departmentId` to the `Appointment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `departmentId` to the `Doctor` table without a default value. This is not possible if the table is not empty.
  - Added the required column `doctorId` to the `MedicalRecord` table without a default value. This is not possible if the table is not empty.
  - Added the required column `queueNumber` to the `Queue` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('APPOINTMENT', 'QUEUE', 'LAB', 'SYSTEM');

-- AlterEnum
ALTER TYPE "AppointmentStatus" ADD VALUE 'NO_SHOW';

-- AlterTable
ALTER TABLE "Appointment" DROP COLUMN "date",
ADD COLUMN     "appointmentDate" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "departmentId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Doctor" DROP COLUMN "department",
ADD COLUMN     "departmentId" INTEGER NOT NULL,
ADD COLUMN     "licenseNumber" TEXT;

-- AlterTable
ALTER TABLE "LabResult" ADD COLUMN     "description" TEXT;

-- AlterTable
ALTER TABLE "MedicalRecord" ADD COLUMN     "doctorId" INTEGER NOT NULL,
ADD COLUMN     "note" TEXT,
ADD COLUMN     "symptom" TEXT;

-- AlterTable
ALTER TABLE "Patient" ADD COLUMN     "address" TEXT;

-- AlterTable
ALTER TABLE "Queue" DROP COLUMN "number",
ADD COLUMN     "calledAt" TIMESTAMP(3),
ADD COLUMN     "checkInTime" TIMESTAMP(3),
ADD COLUMN     "queueNumber" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "lineUserId" TEXT,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- CreateTable
CREATE TABLE "Department" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "type" "NotificationType" NOT NULL,
    "message" TEXT NOT NULL,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "News" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "News_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HospitalSetting" (
    "id" SERIAL NOT NULL,
    "hospitalName" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "checkInRadius" INTEGER NOT NULL DEFAULT 100,
    "queueStartTime" TEXT,

    CONSTRAINT "HospitalSetting_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER,
    "action" TEXT NOT NULL,
    "detail" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChatHistory" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "message" TEXT NOT NULL,
    "response" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChatHistory_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Department_name_key" ON "Department"("name");

-- CreateIndex
CREATE UNIQUE INDEX "User_lineUserId_key" ON "User"("lineUserId");

-- AddForeignKey
ALTER TABLE "Doctor" ADD CONSTRAINT "Doctor_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "Department"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "Department"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MedicalRecord" ADD CONSTRAINT "MedicalRecord_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "Doctor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChatHistory" ADD CONSTRAINT "ChatHistory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
