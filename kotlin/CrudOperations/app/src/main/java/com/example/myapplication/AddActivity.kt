package com.example.myapplication

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class AddActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.add_view_activity)
    }

    fun addDog(view: View) {
        var correct = true
        val nameText = findViewById<EditText>(R.id.nameInput).text.toString()
        val breedText = findViewById<EditText>(R.id.breedInput).text.toString()
        var yearOfBirthText = findViewById<EditText>(R.id.yearOfBirthInput).text.toString()
        val arrivalDateText = findViewById<EditText>(R.id.arrivaldateInput).text.toString()
        var medicalDetailsText = findViewById<EditText>(R.id.medicalDetailsInput).text.toString()
        val crateNumberText = findViewById<EditText>(R.id.crateNoInput).text.toString()

        if (yearOfBirthText == "") {
            yearOfBirthText = "0"
        }
        if (medicalDetailsText == "") {
            medicalDetailsText = ""
        }

        if (nameText == "") {
            Toast.makeText(this, "You must add product name!", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (breedText == "") {
            Toast.makeText(this, "You must add a breed!", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (arrivalDateText == "") {
            Toast.makeText(this, "You must add the arrival date", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (yearOfBirthText.toInt() < 0) {
            Toast.makeText(this, "Year of birth must be positive number!", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (crateNumberText == "") {
            Toast.makeText(this, "You must add the crate number", Toast.LENGTH_LONG).show()
            correct = false
        }
        if (crateNumberText.toInt() < 0) {
            Toast.makeText(this, "Crate number must be positive number!", Toast.LENGTH_LONG).show()
            correct = false
        }

        val dog = Dog(
            nameText,
            breedText,
            yearOfBirthText.toInt(),
            arrivalDateText,
            medicalDetailsText,
            crateNumberText.toInt()
        )

        if (correct) {
            val intent = Intent()
            val bundle = Bundle()
            bundle.putParcelable("dog", dog)
            intent.putExtra("dogBundle", bundle)
            setResult(RESULT_OK, intent)
            finish()
        }
    }

    fun goBack(view: View) {
        intent = Intent()
        finish()
    }
}