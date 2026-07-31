import { NextResponse } from "next/server";
import { verifyToken } from "@/middleware/auth";


export function requireRole(
    req: Request,
    allowedRoles:string[]
){

    const header =
        req.headers.get("authorization");


    if(!header){

        return {
            error: NextResponse.json(
                {
                    message:"Missing token"
                },
                {
                    status:401
                }
            )
        };

    }


    const token = header.split(" ")[1];


    const user = verifyToken(token) as {
        id:number;
        email:string;
        role:string;
    } | null;



    if(!user){

        return {
            error:NextResponse.json(
                {
                    message:"Invalid token"
                },
                {
                    status:401
                }
            )
        };

    }



    if(!allowedRoles.includes(user.role)){

        return {
            error:NextResponse.json(
                {
                    message:"Permission denied"
                },
                {
                    status:403
                }
            )
        };

    }


    return {
        user
    };

}