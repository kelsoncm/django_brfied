# Generated by Django 2.1.4 on 2019-02-27 23:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('django_brfied', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='unidadefederativa',
            name='regiao',
            field=models.CharField(choices=[('N', 'Norte'), ('NE', 'Nordeste'), ('SE', 'Sudeste'), ('S', 'Sul'), ('CO', 'Centro-oeste')], max_length=2, verbose_name='Região'),
        ),
    ]
