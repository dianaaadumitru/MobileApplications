package com.example.myapplication

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import kotlinx.android.synthetic.main.list_view_activity.*
import java.util.*

class ListViewActivity: AppCompatActivity() {
    private val dogs = mutableListOf<Dog>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.list_view_activity)
        initDogs()
        recyclerView.layoutManager = LinearLayoutManager(this)
        recyclerView.adapter = RecyclerAdapter(dogs)
    }

    @SuppressLint("NotifyDataSetChanged")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 3) {
            if (resultCode == RESULT_OK) {
                val bundle = data?.getBundleExtra("itemBundle")
                val dog = bundle?.getParcelable<Dog>("dog")
                if (dog != null) {
                    addDog(dog)
                    Toast.makeText(this, "added!", Toast.LENGTH_SHORT).show()
                    recyclerView.adapter?.notifyDataSetChanged()
                }
            }
        }
        if (requestCode == 5) {
            if (resultCode == RESULT_OK) {
                val dog = data?.getParcelableExtra<Dog>("dog")
                val pos = data?.getIntExtra("position", 0) as Int
                if (dog != null) {
                    editDog(dog, pos)
                    Toast.makeText(this, "updated!", Toast.LENGTH_SHORT).show()
                    recyclerView.adapter?.notifyDataSetChanged()
                }
            }
        }
    }

    fun goAddDog(view: View) {
        intent = Intent(applicationContext, AddActivity::class.java)
        startActivityForResult(intent, 3)
    }

    private fun addDog(dog: Dog) {
        dogs.add(dog)
    }

    private fun editDog(dog: Dog, position: Int){
        dogs[position] = dog;
    }


    private fun initDogs(){
        val dog1 = Dog("Max", "Pitt-Bull type", 2019, Date(2022-10-16),
            "vaccines up to date", 2)
        val dog2 = Dog("Bella", "Bichon type", 0, Date(2022-10-16),
            "", 1
        )
        val dog3 = Dog("Frodo", "German Shepherd type", 2021, Date(2002-10-7),
            "vaccines up to date; sensitive stomach", 2)

        dogs.add(dog1)
        dogs.add(dog2)
        dogs.add(dog3)
    }
}