-- Local setup-order adaptation; original source unchanged.
ALTER TABLE public.staff ADD CONSTRAINT staff_pkey PRIMARY KEY (staff_id);
ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_received_by_fkey FOREIGN KEY (received_by) REFERENCES public.staff(staff_id);


--
-- Name: rental rental_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rental
    ADD CONSTRAINT rental_pkey PRIMARY KEY (rental_id);


--
-- Name: rental_rate rental_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rental_rate
    ADD CONSTRAINT rental_rate_pkey PRIMARY KEY (rate_id);


--
-- Name: rental_terms rental_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rental_terms
    ADD CONSTRAINT rental_terms_pkey PRIMARY KEY (terms_id);


--
-- Name: rental_terms rental_terms_rental_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rental_terms
    ADD CONSTRAINT rental_terms_rental_id_key UNIQUE (rental_id);


--
-- Name: staff staff_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff
    ADD CONSTRAINT staff_email_key UNIQUE (email);


--
-- Name: staff staff_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--




--
-- Name: vehicle_category vehicle_category_category_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle_category
    ADD CONSTRAINT vehicle_category_category_name_key UNIQUE (category_name);


--
-- Name: vehicle_category vehicle_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle_category
    ADD CONSTRAINT vehicle_category_pkey PRIMARY KEY (category_id);


--
-- Name: vehicle_inspection vehicle_inspection_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle_inspection
    ADD CONSTRAINT vehicle_inspection_pkey PRIMARY KEY (inspection_id);


--
-- Name: vehicle_maintenance vehicle_maintenance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle_maintenance
    ADD CONSTRAINT vehicle_maintenance_pkey PRIMARY KEY (maintenance_id);


--
-- Name: vehicle vehicle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle
    ADD CONSTRAINT vehicle_pkey PRIMARY KEY (vehicle_id);


--
-- Name: vehicle vehicle_plate_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle
    ADD CONSTRAINT vehicle_plate_number_key UNIQUE (plate_number);


--
-- Name: idx_audit_datetime; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_datetime ON public.audit_log USING btree (action_datetime);


--
-- Name: idx_audit_staff; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_staff ON public.audit_log USING btree (staff_id);


--
-- Name: idx_damage_fee_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_damage_fee_status ON public.damage_fee USING btree (fee_status);


--
-- Name: idx_license_customer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_license_customer ON public.driver_license USING btree (customer_id);


--
-- Name: idx_license_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_license_status ON public.driver_license USING btree (verification_status);


--
-- Name: idx_maintenance_vehicle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_maintenance_vehicle ON public.vehicle_maintenance USING btree (vehicle_id);


--
-- Name: idx_payment_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payment_status ON public.payment USING btree (payment_status);


--
-- Name: idx_rental_customer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rental_customer ON public.rental USING btree (customer_id);


--
-- Name: idx_rental_dates; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rental_dates ON public.rental USING btree (pickup_datetime, return_datetime);


--
-- Name: idx_rental_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rental_status ON public.rental USING btree (rental_status);


--
-- Name: idx_rental_vehicle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rental_vehicle ON public.rental USING btree (vehicle_id);


--
-- Name: idx_vehicle_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vehicle_status ON public.vehicle USING btree (status);


--
-- Name: audit_log fk_audit_staff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT fk_audit_staff FOREIGN KEY (staff_id) REFERENCES public.staff(staff_id);


--
-- Name: cancellation fk_cancellation_rental; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cancellation
    ADD CONSTRAINT fk_cancellation_rental FOREIGN KEY (rental_id) REFERENCES public.rental(rental_id);


--
-- Name: cancellation fk_cancelled_by_customer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cancellation
    ADD CONSTRAINT fk_cancelled_by_customer FOREIGN KEY (cancelled_by_customer_id) REFERENCES public.customer(customer_id);


--
-- Name: cancellation fk_cancelled_by_staff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cancellation
    ADD CONSTRAINT fk_cancelled_by_staff FOREIGN KEY (cancelled_by_staff_id) REFERENCES public.staff(staff_id);


--
-- Name: damage_fee fk_damage_fee_damage; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.damage_fee
    ADD CONSTRAINT fk_damage_fee_damage FOREIGN KEY (damage_id) REFERENCES public.damage_incident(damage_id);


--
-- Name: damage_incident fk_damage_inspection; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.damage_incident
    ADD CONSTRAINT fk_damage_inspection FOREIGN KEY (inspection_id) REFERENCES public.vehicle_inspection(inspection_id);


--
-- Name: vehicle_inspection fk_inspection_customer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle_inspection
    ADD CONSTRAINT fk_inspection_customer FOREIGN KEY (performed_by_customer_id) REFERENCES public.customer(customer_id);


--
-- Name: vehicle_inspection fk_inspection_rental; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle_inspection
    ADD CONSTRAINT fk_inspection_rental FOREIGN KEY (rental_id) REFERENCES public.rental(rental_id);


--
-- Name: vehicle_inspection fk_inspection_staff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle_inspection
    ADD CONSTRAINT fk_inspection_staff FOREIGN KEY (performed_by_staff_id) REFERENCES public.staff(staff_id);


--
-- Name: driver_license fk_license_customer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.driver_license
    ADD CONSTRAINT fk_license_customer FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: driver_license fk_license_verified_staff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.driver_license
    ADD CONSTRAINT fk_license_verified_staff FOREIGN KEY (verified_by_staff_id) REFERENCES public.staff(staff_id);


--
-- Name: vehicle_maintenance fk_maintenance_vehicle; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle_maintenance
    ADD CONSTRAINT fk_maintenance_vehicle FOREIGN KEY (vehicle_id) REFERENCES public.vehicle(vehicle_id);


--
-- Name: payment fk_payment_damage_fee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT fk_payment_damage_fee FOREIGN KEY (damage_fee_id) REFERENCES public.damage_fee(damage_fee_id);


--
-- Name: payment fk_payment_rental; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES public.rental(rental_id);


--
-- Name: inspection_photo fk_photo_customer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inspection_photo
    ADD CONSTRAINT fk_photo_customer FOREIGN KEY (uploaded_by_customer_id) REFERENCES public.customer(customer_id);


--
-- Name: inspection_photo fk_photo_inspection; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inspection_photo
    ADD CONSTRAINT fk_photo_inspection FOREIGN KEY (inspection_id) REFERENCES public.vehicle_inspection(inspection_id);


--
-- Name: inspection_photo fk_photo_staff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inspection_photo
    ADD CONSTRAINT fk_photo_staff FOREIGN KEY (uploaded_by_staff_id) REFERENCES public.staff(staff_id);


--
-- Name: rental fk_rental_customer; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rental
    ADD CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: rental fk_rental_rate; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rental
    ADD CONSTRAINT fk_rental_rate FOREIGN KEY (rate_id) REFERENCES public.rental_rate(rate_id);


--
-- Name: rental_rate fk_rental_rate_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rental_rate
    ADD CONSTRAINT fk_rental_rate_category FOREIGN KEY (category_id) REFERENCES public.vehicle_category(category_id);


--
-- Name: rental fk_rental_vehicle; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rental
    ADD CONSTRAINT fk_rental_vehicle FOREIGN KEY (vehicle_id) REFERENCES public.vehicle(vehicle_id);


--
-- Name: rental_terms fk_terms_rental; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rental_terms
    ADD CONSTRAINT fk_terms_rental FOREIGN KEY (rental_id) REFERENCES public.rental(rental_id);


--
-- Name: vehicle fk_vehicle_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vehicle
    ADD CONSTRAINT fk_vehicle_category FOREIGN KEY (category_id) REFERENCES public.vehicle_category(category_id);


--
-- PostgreSQL database dump complete
--



-- Condition checklist of an inspection (also created automatically at startup)
CREATE TABLE IF NOT EXISTS inspection_item (
    item_id serial PRIMARY KEY,
    inspection_id integer NOT NULL REFERENCES vehicle_inspection(inspection_id) ON DELETE CASCADE,
    item_name character varying(60) NOT NULL,
    item_condition character varying(30) NOT NULL,
    notes text,
    CONSTRAINT inspection_item_unique UNIQUE (inspection_id, item_name)
);

