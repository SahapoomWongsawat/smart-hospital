import { NextResponse } from "next/server";
import bcrypt from "bcrypt";
import { prisma } from "@/lib/prisma";


export async function POST(req:Request){

    try{


        const body = await req.json();


        const {
            name,
            email,
            password
        } = body;



        const exists = await prisma.user.findUnique({

            where:{
                email
            }

        });



        if(exists){

            return NextResponse.json({

                message:"Email already exists"

            },{
                status:400
            });

        }



        const hashPassword = await bcrypt.hash(
            password,
            10
        );



        const user = await prisma.user.create({

            data:{

                name,

                email,

                password:hashPassword

            }

        });


return NextResponse.json({

    success:true,

    user:{
        id:user.id,
        name:user.name,
        email:user.email,
        role:user.role
    }

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