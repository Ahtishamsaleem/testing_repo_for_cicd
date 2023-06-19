<?php

namespace Tests\Unit;

use App\Models\User;
use Tests\TestCase;



class UserTest extends TestCase
{
    /**
     * A basic unit test example.
     *
     * @return void
     */
    public function test_user_duplication()
    {
        $user1 = User::make([
            'name'=>'ahtisham',
            'email'=>'ahtisham12@gmail.com',
            'password'=>'ahtisham12@gmail.com'
        ]);
        $user2 = User::make([
            'name'=>'ANees',
            'email'=>'ahsan12@gmail.com',
            'password'=>'ahtisham12@gmail.com'
        ]);
        $this->assertTrue($user1->name != $user2->name );

    }

    public function test_delete_user()
    {
        $user = User::factory()->count(1)->make();
        $user = User::first();
        if($user)
        {
            $user->delete();
        }
        $this->assertTrue(true);
    }

    public function test_it_stores_new_users()
    {
        $response = $this->post('/register',[
            'name'=>'Ahtisham',
            'email'=>'ahtishamsaleem@gmail.com',
            'password'=>'234324_3434fsf',
            'password_confirmation'=>'234324_3434fsf'
        ]);
        $response->assertRedirect('/home');
    }
    public function test_database()
    {
        $this->assertDatabaseMissing('users',[
            'email'=>'ahtishamsaleem@gmail.com'
        ]);
    }
    public function test_if_seeders_works()
    {
        $this->seed();
    }
}
