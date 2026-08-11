package eu.codific.dummyapp;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView text = new TextView(this);
        text.setText("DummyApp 1.0.0 — dummy APK for signing tests.");
        setContentView(text);
    }
}
