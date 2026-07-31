import "dotenv/config";

import { PrismaClient } from "@/app/generated/prisma/client";
import { PrismaPg } from "@prisma/adapter-pg";


const adapter = new PrismaPg({
    connectionString: process.env.DATABASE_URL!,
});


const prisma = new PrismaClient({
    adapter,
});


async function main(){

    const user = await prisma.user.update({

        where:{
            email:"admin@test.com"
        },

        data:{
            role:"ADMIN"
        }

    });


    console.log("Updated User:");
    console.log(user);

}


main()
.then(()=>{

    console.log("Role updated successfully");

})
.catch((error)=>{

    console.error(error);

})
.finally(async()=>{

    await prisma.$disconnect();

});