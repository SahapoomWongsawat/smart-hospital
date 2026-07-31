import { prisma } from "@/lib/prisma";
import jwt from "jsonwebtoken";
import { NextResponse } from "next/server";


export async function GET(req: Request) {

    try {

        const authHeader = req.headers.get("authorization");


        if(!authHeader){

            return NextResponse.json(
                {
                    message:"No token"
                },
                {
                    status:401
                }
            );

        }


        const token = authHeader.split(" ")[1];


        const decoded = jwt.verify(
            token,
            process.env.JWT_SECRET!
        ) as {
            id:number;
            email:string;
            role:string;
        };


        const user = await prisma.user.findUnique({

            where:{
                id:decoded.id
            },

            select:{
                id:true,
                name:true,
                email:true,
                role:true
            }

        });


        return NextResponse.json({
            user
        });



    } catch(error){

        return NextResponse.json(
            {
                message:"Invalid token"
            },
            {
                status:401
            }
        );

    }

}