import { prisma } from "@/lib/prisma";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { NextResponse } from "next/server";


export async function POST(req: Request) {

    try {

        const body = await req.json();

        const {
            email,
            password
        } = body;


        // หา User จาก Email

        const user = await prisma.user.findUnique({
            where:{
                email
            }
        });


        if(!user){

            return NextResponse.json(
                {
                    message:"User not found"
                },
                {
                    status:404
                }
            );

        }


        // ตรวจ Password

        const passwordMatch =
            await bcrypt.compare(
                password,
                user.password
            );


        if(!passwordMatch){

            return NextResponse.json(
                {
                    message:"Invalid password"
                },
                {
                    status:401
                }
            );

        }


        // สร้าง JWT

        const token = jwt.sign(

            {
                id:user.id,
                email:user.email,
                role:user.role
            },

            process.env.JWT_SECRET!,

            {
                expiresIn:"7d"
            }

        );


        return NextResponse.json({

            message:"Login success",

            token,

            user:{
                id:user.id,
                name:user.name,
                email:user.email,
                role:user.role
            }

        });



    } catch(error){

        return NextResponse.json(
            {
                message:"Server error",
                error:String(error)
            },
            {
                status:500
            }
        );

    }

}