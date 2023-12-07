package com.dynamsoft.dcp.helloworld;

import static android.view.WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING;
import static android.view.WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE;
import static android.view.WindowManager.LayoutParams.SOFT_INPUT_MODE_CHANGED;
import static android.view.WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN;
import static android.view.WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.TextView;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.ListPopupWindow;

import com.dynamsoft.dcp.CodeParser;
import com.dynamsoft.dcp.CodeParserException;
import com.dynamsoft.dcp.ParsedResultItem;
import com.dynamsoft.dcp.helloworld.databinding.ActivityMainBinding;
import com.dynamsoft.license.LicenseManager;

import java.nio.charset.Charset;

public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;

    private ListPopupWindow popupWindow;

    @SuppressLint("ClickableViewAccessibility")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (savedInstanceState == null) {
            // Initialize license for Dynamsoft Code Parser SDK.
            // The license string here is a time-limited trial license. Note that network connection is required for this license to work.
            // You can also request an extension for your trial license in the customer portal: https://www.dynamsoft.com/customer/license/trialLicense?product=dcp&utm_source=installer&package=android
            LicenseManager.initLicense("DLS2eyJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSJ9", this, (isSuccess, error) -> {
                if (!isSuccess) {
                    error.printStackTrace();
                }
            });
        }

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        initPopupWindowFromEditText(binding.etSourceCode);
        binding.changeFocusView.setOnClickListener(v -> {
            binding.etSourceCode.clearFocus();
            popupWindow.dismiss();
            hideKeyboard(v);
        });

        binding.etSourceCode.setOnTouchListener((v, event)->{
            if(!popupWindow.isShowing() && event.getAction() == MotionEvent.ACTION_DOWN) {
                popupWindow.show();
            }
            return false;
        });

        binding.btnParse.setOnClickListener(v -> {
            binding.pbParsing.setVisibility(View.VISIBLE);
            popupWindow.dismiss();
            new Thread(() -> parseCodeString(binding.etSourceCode.getText().toString())).start();
        });
    }


    @SuppressLint("RestrictedApi")
    private void initPopupWindowFromEditText(EditText et) {
        popupWindow = new ListPopupWindow(this);
        popupWindow.setAdapter(new ArrayAdapter<>(this, R.layout.single_line_simple_list_item, Preset.CODE_STRING));
        popupWindow.setAnchorView(et);
        popupWindow.setDropDownAlwaysVisible(true);
        popupWindow.setHeight((int) (250 * getResources().getDisplayMetrics().density));
        popupWindow.setPromptView(getLayoutInflater().inflate(R.layout.simple_text, null, false));
        popupWindow.setOnItemClickListener((adapterView, view, i, l) -> {
            String text = ((TextView) view.findViewById(R.id.text)).getText().toString();
            et.setText(text.substring(text.indexOf(": ")+2));
            popupWindow.dismiss();
            hideKeyboard(binding.getRoot());
        });
    }

    private void hideKeyboard(View view) {
        InputMethodManager im;
        if ((im = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE)) != null) {
            im.hideSoftInputFromWindow(view.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
        }
    }

    private void parseCodeString(String codeString) {
        // Generate an array of byte from the user input or the preset string.
        // The byte array will be used as the input of Dynamsoft Code Parser.
        byte[] codeStringBytes;
        if (codeString.startsWith("[") && codeString.endsWith("]")) {
            codeStringBytes = Preset.bytesStringToArray(codeString);
        } else {
            codeStringBytes = codeString.getBytes(Charset.defaultCharset());
        }
        // ParsedResultItem is what Dynamsoft Code Parser output. It contains the parsed fields data.
        ParsedResultItem parsedResultItem;
        try {
            // Use the parse method to parse the content.
            parsedResultItem = new CodeParser(this).parse(codeStringBytes, "");
        } catch (CodeParserException e) {
            e.printStackTrace();
            showResult("Parsed failed:", e.getMessage());
            return;
        }
        switch (parsedResultItem.getCodeType()) {
            case "MRTD_TD1_ID":
            case "MRTD_TD2_ID":
            case "MRTD_TD2_VISA":
            case "MRTD_TD3_VISA":
                // Parsed content is stored in a dictionary. The key is field name and the value is the parsed field value.
                // The method getFieldValue is one of the APIs that can extract the parsed content.
                // You can view the APIs references for more mays to extract the parsed content.
                // https://www.dynamsoft.com/code-parser/docs/mobile/programming/android/api-reference/parsed-result-item.html
                showResult("Value of document number:", parsedResultItem.getFieldValue("documentNumber"));
                break;
            case "MRTD_TD2_FRENCH_ID":
            case "SOUTH_AFRICA_DL":
            case "AADHAAR":
                showResult("Value of ID number:", parsedResultItem.getFieldValue("idNumber"));
                break;
            case "MRTD_TD3_PASSPORT":
                showResult("Value of passport number:", parsedResultItem.getFieldValue("passportNumber"));
                break;
            case "AAMVA_DL_ID":
                showResult("Value of license number:", parsedResultItem.getFieldValue("licenseNumber"));
                break;
            case "AAMVA_DL_ID_WITH_MAG_STRIPE":
                showResult("Value of ID number:", parsedResultItem.getFieldValue("DLorID_Number"));
                break;
            case "VIN":
                showResult("Value of WMI:", parsedResultItem.getFieldValue("WMI"));
                break;
            default:
                showResult(parsedResultItem.getCodeType(), parsedResultItem.getParsedFields().toString());
                break;
        }
    }

    private void showResult(String title, String content) {
        runOnUiThread(() -> {
            binding.pbParsing.setVisibility(View.GONE);
            TextView textView = (TextView) getLayoutInflater().inflate(android.R.layout.simple_list_item_1, null);
            textView.setText(content);
            textView.setTextIsSelectable(true);
            new AlertDialog.Builder(this)
                    .setTitle(title)
                    .setView(textView)
                    .setPositiveButton("OK", null)
                    .setCancelable(true)
                    .show();
        });
    }

}