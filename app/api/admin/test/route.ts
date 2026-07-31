import { NextResponse } from "next/server";
import { requireRole } from "@/lib/auth";


export async function GET(req:Request){


    const auth = requireRole(
        req,
        [
            "ADMIN"
        ]
    );


    if(auth.error){

        return auth.error;

    }


    return NextResponse.json({

        message:"Admin Access Granted",

        user:auth.user

    });


}