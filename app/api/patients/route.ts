import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";


// GET /api/patients
export async function GET(){

    try{

        const patients = await prisma.patient.findMany({

            include:{
                user:true
            }

        });


        return NextResponse.json({

            success:true,

            patients

        });


    }catch(error){

        return NextResponse.json({

            success:false,

            error:String(error)

        },{
            status:500
        });

    }

}



// POST /api/patients
export async function POST(req:Request){

    try{


        const body = await req.json();


        const {
            userId,
            phone,
            birthDate
        } = body;



        const patient = await prisma.patient.create({

            data:{

                userId,

                phone,

                birthDate:new Date(birthDate)

            }

        });



        return NextResponse.json({

            success:true,

            patient

        });


    }catch(error){


        return NextResponse.json({

            success:false,

            error:String(error)

        },{
            status:500
        });


    }

}