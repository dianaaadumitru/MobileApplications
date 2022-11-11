package com.example.myapplication

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize
import java.util.Date

@Parcelize
data class Dog(
    val name: String, val breed: String, val yearOfBirth: Number, val arrivalDate: String,
    val medicalDetails: String, val crateNo: Number
) : Parcelable