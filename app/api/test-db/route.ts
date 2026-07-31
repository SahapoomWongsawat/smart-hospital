import { prisma } from "@/lib/prisma";
import { NextResponse } from "next/server";


export async function GET() {

  try {

    const users = await prisma.user.findMany();

    return NextResponse.json({
      success: true,
      data: users
    });


  } catch (error) {

    console.error(error);

    return NextResponse.json(
      {
        success: false,
        error: String(error)
      },
      {
        status:500
      }
    );

  }

}