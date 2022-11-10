package com.example.myapplication

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
data class Item(val name: String, val quantity: Int, val price: Int, val category: String, val note: String)
    :Parcelable